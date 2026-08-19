import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'chinese_segmenter.dart';

part 'database.g.dart';

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hskLevel => integer()();
  TextColumn get chinese => text()();
  TextColumn get pinyin => text()();

  TextColumn get pinyinPlain => text().nullable()();
  TextColumn get pinyinInitials => text().nullable()();

  TextColumn get english => text()();
  TextColumn get myanmar => text().nullable()();
  TextColumn get exampleSentenceCn => text().nullable()();
  TextColumn get exampleSentencePinyin => text().nullable()();
  TextColumn get exampleSentenceEng => text().nullable()();
  TextColumn get exampleSentenceMy => text().nullable()();
  TextColumn get relatedWords => text().nullable()();
  TextColumn get favoritedAt => text().nullable()();
}

enum MatchCategory {
  exactPinyinOrHanzi,
  pinyinSyllables,
  strongEnglishOrMy,
  weakEnglishOrMy,
  none,
}

@DriftDatabase(tables: [Words])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  Set<String>? _dictionaryHanziCache;

  // Helper 1: Tone Marks ဖြုတ်ပေးသည့် ဖန်ရှင်
  static String removePinyinTones(String input) {
    const withTones = 'āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ';
    const withoutTones = 'aaaaeeeeiiiioooouuuuvvvv';
    String result = input.toLowerCase();
    for (int i = 0; i < withTones.length; i++) {
      result = result.replaceAll(withTones[i], withoutTones[i]);
    }
    return result;
  }

  // Helper 2: Pinyin အစစာလုံးများ ခွဲထုတ်ပေးသည့် ဖန်ရှင်
  static String getPinyinInitials(String pinyinPlain) {
    List<String> wordsList = pinyinPlain.split(RegExp(r"[\s'-]+"));
    String initials = '';
    for (var word in wordsList) {
      if (word.isNotEmpty) {
        initials += word[0];
      }
    }
    return initials;
  }

  // Dictionary ထဲရှိ တရုတ်စာလုံးများကို Cache လုပ်ထားပေးသည့် ဖန်ရှင်
  Future<Set<String>> _getDictionaryHanziSet() async {
    if (_dictionaryHanziCache != null) return _dictionaryHanziCache!;
    final allWords = await select(words).get();
    _dictionaryHanziCache = allWords.map((w) => w.chinese).toSet();
    return _dictionaryHanziCache!;
  }

  // Search Words Logic
  Future<List<Word>> searchWords(String query, {int limit = 20}) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    // -------------------------------------------------------------
    // ၁။ တရုတ် စာကြောင်းလိုက် Segmentation (e.g. 我们哭了)
    // -------------------------------------------------------------
    final bool isChineseSentence = RegExp(r'[\u4e00-\u9fa5]').hasMatch(cleanQuery) && cleanQuery.length > 2;

    if (isChineseSentence) {
      final hanziSet = await _getDictionaryHanziSet();
      final segmentedTokens = ChineseSegmenter.segment(cleanQuery, hanziSet);

      List<Word> segmentedResults = [];
      for (String token in segmentedTokens) {
        // .get() သုံးထားသဖြင့် 了 ကဲ့သို့ စာလုံးအများအပြားရှိသည့် စာလုံးများအတွက် Exception Error မတက်တော့ပါ
        final matches = await (select(words)..where((tbl) => tbl.chinese.equals(token))).get();
        if (matches.isNotEmpty) {
          segmentedResults.addAll(matches);
        }
      }

      if (segmentedResults.isNotEmpty) {
        return segmentedResults;
      }
    }

    // -------------------------------------------------------------
    // ၂။ Pinyin / Hanzi / English Search Logic
    // -------------------------------------------------------------
    final queryNoTones = removePinyinTones(cleanQuery.toLowerCase());
    final queryNoSpace = queryNoTones.replaceAll(RegExp(r"[\s'-]+"), '');

    final pPlainNoSpaceExpr = CustomExpression<String>(
      "REPLACE(REPLACE(COALESCE(pinyin_plain, ''), ' ', ''), '-', '')"
    );

    final q = select(words)
      ..where((tbl) {
        final cn = tbl.chinese.like('%$cleanQuery%');
        final pPlain1 = tbl.pinyinPlain.like('%$queryNoTones%');
        final pPlain2 = pPlainNoSpaceExpr.like('%$queryNoSpace%');
        final pInit1 = tbl.pinyinInitials.like('%$queryNoTones%');
        final pInit2 = tbl.pinyinInitials.like('%$queryNoSpace%');
        final en = tbl.english.like('%$cleanQuery%');
        final my = tbl.myanmar.like('%$cleanQuery%');

        return cn | pPlain1 | pPlain2 | pInit1 | pInit2 | en | my;
      });

    final rawResults = await q.get();

    final Map<Word, MatchCategory> categorized = {};
    for (var word in rawResults) {
      final cat = _getMatchCategory(word, queryNoTones, queryNoSpace);
      if (cat != MatchCategory.none) {
        categorized[word] = cat;
      }
    }

    bool hasStrongMatches = categorized.values.any((cat) => 
      cat == MatchCategory.exactPinyinOrHanzi || 
      cat == MatchCategory.pinyinSyllables || 
      cat == MatchCategory.strongEnglishOrMy
    );

    final filteredList = categorized.entries.where((entry) {
      if (hasStrongMatches && entry.value == MatchCategory.weakEnglishOrMy) {
        return false;
      }
      return true;
    }).map((e) => e.key).toList();

    filteredList.sort((a, b) {
      int catA = categorized[a]!.index;
      int catB = categorized[b]!.index;
      if (catA != catB) {
        return catA.compareTo(catB);
      }
      return a.chinese.length.compareTo(b.chinese.length);
    });

    return filteredList.take(limit).toList();
  }

  MatchCategory _getMatchCategory(Word word, String query, String queryNoSpace) {
    final cn = word.chinese.toLowerCase();
    final pPlain = (word.pinyinPlain ?? '').toLowerCase();
    final pPlainNoSpace = pPlain.replaceAll(RegExp(r"[\s'-]+"), '');
    final pInit = (word.pinyinInitials ?? '').toLowerCase();
    final en = word.english.toLowerCase();
    final my = (word.myanmar ?? '').toLowerCase();

    if (cn == query || pPlain == query || pPlainNoSpace == queryNoSpace) {
      return MatchCategory.exactPinyinOrHanzi;
    }

    if (_isStrictPinyinMatch(pPlain, query, queryNoSpace) || pInit.startsWith(query) || pInit.startsWith(queryNoSpace) || cn.contains(query)) {
      return MatchCategory.pinyinSyllables;
    }

    final enWords = en.split(RegExp(r"[^\w]+"));
    final myWords = my.split(RegExp(r"\s+"));
    
    if (enWords.contains(query) || myWords.contains(query)) {
      return MatchCategory.strongEnglishOrMy;
    }

    if (enWords.any((w) => w.startsWith(query)) || myWords.any((w) => w.startsWith(query))) {
      return MatchCategory.weakEnglishOrMy;
    }

    return MatchCategory.none;
  }

  bool _isStrictPinyinMatch(String pinyinPlain, String query, String queryNoSpace) {
    final pPlainNoSpace = pinyinPlain.replaceAll(RegExp(r"[\s'-]+"), '');

    if (pPlainNoSpace == queryNoSpace) return true;

    if (pPlainNoSpace.startsWith(queryNoSpace)) {
      if (queryNoSpace.endsWith('n') && pPlainNoSpace.length > queryNoSpace.length && pPlainNoSpace[queryNoSpace.length] == 'g') {
        return false; 
      }
      return true;
    }

    List<String> syllables = pinyinPlain.split(RegExp(r"[\s'-]+"));
    for (String s in syllables) {
      if (s == query) return true;
      if (s.startsWith(query)) {
        if (query.endsWith('n') && s.length > query.length && s[query.length] == 'g') {
          continue; 
        }
        return true;
      }
    }

    return false;
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dictionary_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}