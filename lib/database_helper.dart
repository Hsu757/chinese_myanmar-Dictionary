import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'database.dart'; 
import 'storage_service.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static AppDatabase? _database;

  DatabaseHelper._init();

  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = AppDatabase();
    return _database!;
  }

  Future<void> importCsvToDatabase() async {
    final dbInstance = await database;
    try {
      final existingWords = await dbInstance.select(dbInstance.words).get();
      if (existingWords.isNotEmpty) {
        debugPrint("Database ထဲတွင် Data ရှိပြီးသားဖြစ်၍ CSV ကို ထပ်မသွင်းတော့ပါ။");
        return; 
      }

      final rawData = await rootBundle.loadString('assets/hsk_01.csv');
      List<String> lines = rawData.split('\n');

      final RegExp csvRegExp = RegExp(r'(?:^|,)(?:"([^"]*)"|([^,]*))');

      for (int i = 1; i < lines.length; i++) {
        String line = lines[i].trim();
        if (line.isEmpty) continue;

        List<String> columns = [];
        for (final match in csvRegExp.allMatches(line)) {
          String? val = match.group(1) ?? match.group(2);
          columns.add(val?.trim() ?? '');
        }

        if (columns.length >= 6) {
          String pinyinVal = columns[3];

          String plainVal = AppDatabase.removePinyinTones(pinyinVal);
          String initialsVal = AppDatabase.getPinyinInitials(plainVal);

          await dbInstance.into(dbInstance.words).insert(
            WordsCompanion.insert(
              hskLevel: int.tryParse(columns[1]) ?? 1,
              chinese: columns[2],
              pinyin: pinyinVal,
              pinyinPlain: Value(plainVal),
              pinyinInitials: Value(initialsVal),
              english: columns[4],
              myanmar: Value(columns[5]),
              
              exampleSentenceCn: columns.length > 6 ? Value(columns[6]) : const Value.absent(),
              exampleSentencePinyin: columns.length > 7 ? Value(columns[7]) : const Value.absent(),
              exampleSentenceEng: columns.length > 8 ? Value(columns[8]) : const Value.absent(),
              exampleSentenceMy: columns.length > 9 ? Value(columns[9]) : const Value.absent(),
              relatedWords: columns.length > 10 ? Value(columns[10]) : const Value.absent(),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      debugPrint("HSK Data Import အောင်မြင်ပါပြီ!");
    } catch (e) {
      debugPrint("Error ဖြစ်ပွားသည်: $e");
    }
  }

  // 🧠 အမှားအယွင်းကင်းစင်ပြီး တိကျသော Smart Tier-based Search Logic (မြန်မာလိုပါ ရှာနိုင်ရန် ထည့်သွင်းထားသည်)
  Future<List<Word>> searchWords(String query) async {
    final db = await database;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final qNoSpace = q.replaceAll(' ', '');

    // ၁။ တရုတ်စာလုံး ရှာဖွေခြင်း (Chinese Query)
    if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(q)) {
      final exactCn = await (db.select(db.words)..where((t) => t.chinese.equals(q))).get();
      if (exactCn.isNotEmpty) return exactCn;

      List<Word> results = [];
      if (q.length == 1) {
        results = await (db.select(db.words)..where((t) => t.chinese.like('$q%'))).get();
      } else {
        for (var char in q.split('')) {
          if (char.trim().isEmpty) continue;
          final charRes = await (db.select(db.words)..where((t) => t.chinese.equals(char))).get();
          results.addAll(charRes);
        }
      }
      return results.toSet().toList();
    }

    // ၂။ English ရှာဖွေခြင်း
    final exactEng = await (db.select(db.words)..where((t) => t.english.lower().equals(q))).get();
    final prefixEng = await (db.select(db.words)..where((t) => t.english.lower().like('$q%'))).get();

    // ၃။ မြန်မာစာ ရှာဖွေခြင်း (Myanmar Query - အသစ်ထည့်သွင်းပေးထားသည်)
    final exactMy = await (db.select(db.words)..where((t) => t.myanmar.lower().equals(q))).get();
    final prefixMy = await (db.select(db.words)..where((t) => t.myanmar.lower().like('%$q%'))).get();

    // ၄။ Pinyin ရှာဖွေခြင်း
    final exactPin = await (db.select(db.words)..where((t) => 
        t.pinyinPlain.lower().equals(q) | 
        t.pinyinPlain.lower().equals(qNoSpace)
    )).get();

    // 💡 xie xie လို့ Space ခြားရိုက်ရင်တောင် qNoSpace (xiexie) နဲ့ ရှာမို့လို့ prefixPin ထဲမှာ xiexie ဝင်လာပါမယ်
    final prefixPin = await (db.select(db.words)..where((t) => 
        t.pinyinPlain.lower().like('$q%') | 
        t.pinyinPlain.lower().like('$qNoSpace%')
    )).get();

    // ၅။ Token ဖြင့် ရှာဖွေခြင်း (Combined/Prefix ရှာလို့ မတွေ့မှသာ နှင့် Space ပါမှ အလုပ်လုပ်မည်)
    List<Word> tokenRes = [];
    if (prefixPin.isEmpty && q.contains(' ')) {
      final tokens = q.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      for (var token in tokens) {
        // like ကို မသုံးတော့ဘဲ equals ကိုသာ သုံးထား၍ မဆိုင်တာတွေ လျှောက်မပါလာပါ
        final tRes = await (db.select(db.words)..where((t) => 
            t.pinyinPlain.lower().equals(token)
        )).get();
        tokenRes.addAll(tRes);
      }
    }

    // ၆။ Smart Ranking (Tier အလိုက် ထိပ်ဆုံးမှ စီပေးခြင်း - မြန်မာရလဒ်များကိုပါ ထည့်သွင်းပေးထားသည်)
    final orderedResults = [
      ...exactEng,
      ...exactMy,
      ...exactPin,
      ...prefixPin,
      ...prefixEng,
      ...prefixMy,
      ...tokenRes,
    ];

    return orderedResults.toSet().toList();
  }

  Future<List<Word>> getHistory() async {
    try {
      final List<Map<String, dynamic>> historyMaps = await StorageService.getHistory();
      return historyMaps.map((map) => Word.fromJson(map)).toList();
    } catch (e) {
      debugPrint("Get History Error: $e");
      return [];
    }
  }

  Future<List<Word>> getFavorites() async {
    try {
      final List<Map<String, dynamic>> favMaps = await StorageService.getFavorites();
      return favMaps.map((map) => Word.fromJson(map)).toList();
    } catch (e) {
      debugPrint("Get Favorites Error: $e");
      return [];
    }
  }
}