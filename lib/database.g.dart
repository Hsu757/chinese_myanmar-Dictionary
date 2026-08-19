// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hskLevelMeta = const VerificationMeta(
    'hskLevel',
  );
  @override
  late final GeneratedColumn<int> hskLevel = GeneratedColumn<int>(
    'hsk_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chineseMeta = const VerificationMeta(
    'chinese',
  );
  @override
  late final GeneratedColumn<String> chinese = GeneratedColumn<String>(
    'chinese',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
    'pinyin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinyinPlainMeta = const VerificationMeta(
    'pinyinPlain',
  );
  @override
  late final GeneratedColumn<String> pinyinPlain = GeneratedColumn<String>(
    'pinyin_plain',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinyinInitialsMeta = const VerificationMeta(
    'pinyinInitials',
  );
  @override
  late final GeneratedColumn<String> pinyinInitials = GeneratedColumn<String>(
    'pinyin_initials',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _englishMeta = const VerificationMeta(
    'english',
  );
  @override
  late final GeneratedColumn<String> english = GeneratedColumn<String>(
    'english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _myanmarMeta = const VerificationMeta(
    'myanmar',
  );
  @override
  late final GeneratedColumn<String> myanmar = GeneratedColumn<String>(
    'myanmar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleSentenceCnMeta = const VerificationMeta(
    'exampleSentenceCn',
  );
  @override
  late final GeneratedColumn<String> exampleSentenceCn =
      GeneratedColumn<String>(
        'example_sentence_cn',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exampleSentencePinyinMeta =
      const VerificationMeta('exampleSentencePinyin');
  @override
  late final GeneratedColumn<String> exampleSentencePinyin =
      GeneratedColumn<String>(
        'example_sentence_pinyin',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exampleSentenceEngMeta =
      const VerificationMeta('exampleSentenceEng');
  @override
  late final GeneratedColumn<String> exampleSentenceEng =
      GeneratedColumn<String>(
        'example_sentence_eng',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exampleSentenceMyMeta = const VerificationMeta(
    'exampleSentenceMy',
  );
  @override
  late final GeneratedColumn<String> exampleSentenceMy =
      GeneratedColumn<String>(
        'example_sentence_my',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _relatedWordsMeta = const VerificationMeta(
    'relatedWords',
  );
  @override
  late final GeneratedColumn<String> relatedWords = GeneratedColumn<String>(
    'related_words',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoritedAtMeta = const VerificationMeta(
    'favoritedAt',
  );
  @override
  late final GeneratedColumn<String> favoritedAt = GeneratedColumn<String>(
    'favorited_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hskLevel,
    chinese,
    pinyin,
    pinyinPlain,
    pinyinInitials,
    english,
    myanmar,
    exampleSentenceCn,
    exampleSentencePinyin,
    exampleSentenceEng,
    exampleSentenceMy,
    relatedWords,
    favoritedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hsk_level')) {
      context.handle(
        _hskLevelMeta,
        hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_hskLevelMeta);
    }
    if (data.containsKey('chinese')) {
      context.handle(
        _chineseMeta,
        chinese.isAcceptableOrUnknown(data['chinese']!, _chineseMeta),
      );
    } else if (isInserting) {
      context.missing(_chineseMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(
        _pinyinMeta,
        pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta),
      );
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('pinyin_plain')) {
      context.handle(
        _pinyinPlainMeta,
        pinyinPlain.isAcceptableOrUnknown(
          data['pinyin_plain']!,
          _pinyinPlainMeta,
        ),
      );
    }
    if (data.containsKey('pinyin_initials')) {
      context.handle(
        _pinyinInitialsMeta,
        pinyinInitials.isAcceptableOrUnknown(
          data['pinyin_initials']!,
          _pinyinInitialsMeta,
        ),
      );
    }
    if (data.containsKey('english')) {
      context.handle(
        _englishMeta,
        english.isAcceptableOrUnknown(data['english']!, _englishMeta),
      );
    } else if (isInserting) {
      context.missing(_englishMeta);
    }
    if (data.containsKey('myanmar')) {
      context.handle(
        _myanmarMeta,
        myanmar.isAcceptableOrUnknown(data['myanmar']!, _myanmarMeta),
      );
    }
    if (data.containsKey('example_sentence_cn')) {
      context.handle(
        _exampleSentenceCnMeta,
        exampleSentenceCn.isAcceptableOrUnknown(
          data['example_sentence_cn']!,
          _exampleSentenceCnMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence_pinyin')) {
      context.handle(
        _exampleSentencePinyinMeta,
        exampleSentencePinyin.isAcceptableOrUnknown(
          data['example_sentence_pinyin']!,
          _exampleSentencePinyinMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence_eng')) {
      context.handle(
        _exampleSentenceEngMeta,
        exampleSentenceEng.isAcceptableOrUnknown(
          data['example_sentence_eng']!,
          _exampleSentenceEngMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence_my')) {
      context.handle(
        _exampleSentenceMyMeta,
        exampleSentenceMy.isAcceptableOrUnknown(
          data['example_sentence_my']!,
          _exampleSentenceMyMeta,
        ),
      );
    }
    if (data.containsKey('related_words')) {
      context.handle(
        _relatedWordsMeta,
        relatedWords.isAcceptableOrUnknown(
          data['related_words']!,
          _relatedWordsMeta,
        ),
      );
    }
    if (data.containsKey('favorited_at')) {
      context.handle(
        _favoritedAtMeta,
        favoritedAt.isAcceptableOrUnknown(
          data['favorited_at']!,
          _favoritedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hsk_level'],
      )!,
      chinese: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chinese'],
      )!,
      pinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin'],
      )!,
      pinyinPlain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin_plain'],
      ),
      pinyinInitials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinyin_initials'],
      ),
      english: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english'],
      )!,
      myanmar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}myanmar'],
      ),
      exampleSentenceCn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_cn'],
      ),
      exampleSentencePinyin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_pinyin'],
      ),
      exampleSentenceEng: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_eng'],
      ),
      exampleSentenceMy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_my'],
      ),
      relatedWords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_words'],
      ),
      favoritedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorited_at'],
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
  final int hskLevel;
  final String chinese;
  final String pinyin;
  final String? pinyinPlain;
  final String? pinyinInitials;
  final String english;
  final String? myanmar;
  final String? exampleSentenceCn;
  final String? exampleSentencePinyin;
  final String? exampleSentenceEng;
  final String? exampleSentenceMy;
  final String? relatedWords;
  final String? favoritedAt;
  const Word({
    required this.id,
    required this.hskLevel,
    required this.chinese,
    required this.pinyin,
    this.pinyinPlain,
    this.pinyinInitials,
    required this.english,
    this.myanmar,
    this.exampleSentenceCn,
    this.exampleSentencePinyin,
    this.exampleSentenceEng,
    this.exampleSentenceMy,
    this.relatedWords,
    this.favoritedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hsk_level'] = Variable<int>(hskLevel);
    map['chinese'] = Variable<String>(chinese);
    map['pinyin'] = Variable<String>(pinyin);
    if (!nullToAbsent || pinyinPlain != null) {
      map['pinyin_plain'] = Variable<String>(pinyinPlain);
    }
    if (!nullToAbsent || pinyinInitials != null) {
      map['pinyin_initials'] = Variable<String>(pinyinInitials);
    }
    map['english'] = Variable<String>(english);
    if (!nullToAbsent || myanmar != null) {
      map['myanmar'] = Variable<String>(myanmar);
    }
    if (!nullToAbsent || exampleSentenceCn != null) {
      map['example_sentence_cn'] = Variable<String>(exampleSentenceCn);
    }
    if (!nullToAbsent || exampleSentencePinyin != null) {
      map['example_sentence_pinyin'] = Variable<String>(exampleSentencePinyin);
    }
    if (!nullToAbsent || exampleSentenceEng != null) {
      map['example_sentence_eng'] = Variable<String>(exampleSentenceEng);
    }
    if (!nullToAbsent || exampleSentenceMy != null) {
      map['example_sentence_my'] = Variable<String>(exampleSentenceMy);
    }
    if (!nullToAbsent || relatedWords != null) {
      map['related_words'] = Variable<String>(relatedWords);
    }
    if (!nullToAbsent || favoritedAt != null) {
      map['favorited_at'] = Variable<String>(favoritedAt);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      hskLevel: Value(hskLevel),
      chinese: Value(chinese),
      pinyin: Value(pinyin),
      pinyinPlain: pinyinPlain == null && nullToAbsent
          ? const Value.absent()
          : Value(pinyinPlain),
      pinyinInitials: pinyinInitials == null && nullToAbsent
          ? const Value.absent()
          : Value(pinyinInitials),
      english: Value(english),
      myanmar: myanmar == null && nullToAbsent
          ? const Value.absent()
          : Value(myanmar),
      exampleSentenceCn: exampleSentenceCn == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentenceCn),
      exampleSentencePinyin: exampleSentencePinyin == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentencePinyin),
      exampleSentenceEng: exampleSentenceEng == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentenceEng),
      exampleSentenceMy: exampleSentenceMy == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentenceMy),
      relatedWords: relatedWords == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedWords),
      favoritedAt: favoritedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(favoritedAt),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      hskLevel: serializer.fromJson<int>(json['hskLevel']),
      chinese: serializer.fromJson<String>(json['chinese']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      pinyinPlain: serializer.fromJson<String?>(json['pinyinPlain']),
      pinyinInitials: serializer.fromJson<String?>(json['pinyinInitials']),
      english: serializer.fromJson<String>(json['english']),
      myanmar: serializer.fromJson<String?>(json['myanmar']),
      exampleSentenceCn: serializer.fromJson<String?>(
        json['exampleSentenceCn'],
      ),
      exampleSentencePinyin: serializer.fromJson<String?>(
        json['exampleSentencePinyin'],
      ),
      exampleSentenceEng: serializer.fromJson<String?>(
        json['exampleSentenceEng'],
      ),
      exampleSentenceMy: serializer.fromJson<String?>(
        json['exampleSentenceMy'],
      ),
      relatedWords: serializer.fromJson<String?>(json['relatedWords']),
      favoritedAt: serializer.fromJson<String?>(json['favoritedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hskLevel': serializer.toJson<int>(hskLevel),
      'chinese': serializer.toJson<String>(chinese),
      'pinyin': serializer.toJson<String>(pinyin),
      'pinyinPlain': serializer.toJson<String?>(pinyinPlain),
      'pinyinInitials': serializer.toJson<String?>(pinyinInitials),
      'english': serializer.toJson<String>(english),
      'myanmar': serializer.toJson<String?>(myanmar),
      'exampleSentenceCn': serializer.toJson<String?>(exampleSentenceCn),
      'exampleSentencePinyin': serializer.toJson<String?>(
        exampleSentencePinyin,
      ),
      'exampleSentenceEng': serializer.toJson<String?>(exampleSentenceEng),
      'exampleSentenceMy': serializer.toJson<String?>(exampleSentenceMy),
      'relatedWords': serializer.toJson<String?>(relatedWords),
      'favoritedAt': serializer.toJson<String?>(favoritedAt),
    };
  }

  Word copyWith({
    int? id,
    int? hskLevel,
    String? chinese,
    String? pinyin,
    Value<String?> pinyinPlain = const Value.absent(),
    Value<String?> pinyinInitials = const Value.absent(),
    String? english,
    Value<String?> myanmar = const Value.absent(),
    Value<String?> exampleSentenceCn = const Value.absent(),
    Value<String?> exampleSentencePinyin = const Value.absent(),
    Value<String?> exampleSentenceEng = const Value.absent(),
    Value<String?> exampleSentenceMy = const Value.absent(),
    Value<String?> relatedWords = const Value.absent(),
    Value<String?> favoritedAt = const Value.absent(),
  }) => Word(
    id: id ?? this.id,
    hskLevel: hskLevel ?? this.hskLevel,
    chinese: chinese ?? this.chinese,
    pinyin: pinyin ?? this.pinyin,
    pinyinPlain: pinyinPlain.present ? pinyinPlain.value : this.pinyinPlain,
    pinyinInitials: pinyinInitials.present
        ? pinyinInitials.value
        : this.pinyinInitials,
    english: english ?? this.english,
    myanmar: myanmar.present ? myanmar.value : this.myanmar,
    exampleSentenceCn: exampleSentenceCn.present
        ? exampleSentenceCn.value
        : this.exampleSentenceCn,
    exampleSentencePinyin: exampleSentencePinyin.present
        ? exampleSentencePinyin.value
        : this.exampleSentencePinyin,
    exampleSentenceEng: exampleSentenceEng.present
        ? exampleSentenceEng.value
        : this.exampleSentenceEng,
    exampleSentenceMy: exampleSentenceMy.present
        ? exampleSentenceMy.value
        : this.exampleSentenceMy,
    relatedWords: relatedWords.present ? relatedWords.value : this.relatedWords,
    favoritedAt: favoritedAt.present ? favoritedAt.value : this.favoritedAt,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
      chinese: data.chinese.present ? data.chinese.value : this.chinese,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      pinyinPlain: data.pinyinPlain.present
          ? data.pinyinPlain.value
          : this.pinyinPlain,
      pinyinInitials: data.pinyinInitials.present
          ? data.pinyinInitials.value
          : this.pinyinInitials,
      english: data.english.present ? data.english.value : this.english,
      myanmar: data.myanmar.present ? data.myanmar.value : this.myanmar,
      exampleSentenceCn: data.exampleSentenceCn.present
          ? data.exampleSentenceCn.value
          : this.exampleSentenceCn,
      exampleSentencePinyin: data.exampleSentencePinyin.present
          ? data.exampleSentencePinyin.value
          : this.exampleSentencePinyin,
      exampleSentenceEng: data.exampleSentenceEng.present
          ? data.exampleSentenceEng.value
          : this.exampleSentenceEng,
      exampleSentenceMy: data.exampleSentenceMy.present
          ? data.exampleSentenceMy.value
          : this.exampleSentenceMy,
      relatedWords: data.relatedWords.present
          ? data.relatedWords.value
          : this.relatedWords,
      favoritedAt: data.favoritedAt.present
          ? data.favoritedAt.value
          : this.favoritedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('chinese: $chinese, ')
          ..write('pinyin: $pinyin, ')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('pinyinInitials: $pinyinInitials, ')
          ..write('english: $english, ')
          ..write('myanmar: $myanmar, ')
          ..write('exampleSentenceCn: $exampleSentenceCn, ')
          ..write('exampleSentencePinyin: $exampleSentencePinyin, ')
          ..write('exampleSentenceEng: $exampleSentenceEng, ')
          ..write('exampleSentenceMy: $exampleSentenceMy, ')
          ..write('relatedWords: $relatedWords, ')
          ..write('favoritedAt: $favoritedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hskLevel,
    chinese,
    pinyin,
    pinyinPlain,
    pinyinInitials,
    english,
    myanmar,
    exampleSentenceCn,
    exampleSentencePinyin,
    exampleSentenceEng,
    exampleSentenceMy,
    relatedWords,
    favoritedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.hskLevel == this.hskLevel &&
          other.chinese == this.chinese &&
          other.pinyin == this.pinyin &&
          other.pinyinPlain == this.pinyinPlain &&
          other.pinyinInitials == this.pinyinInitials &&
          other.english == this.english &&
          other.myanmar == this.myanmar &&
          other.exampleSentenceCn == this.exampleSentenceCn &&
          other.exampleSentencePinyin == this.exampleSentencePinyin &&
          other.exampleSentenceEng == this.exampleSentenceEng &&
          other.exampleSentenceMy == this.exampleSentenceMy &&
          other.relatedWords == this.relatedWords &&
          other.favoritedAt == this.favoritedAt);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<int> hskLevel;
  final Value<String> chinese;
  final Value<String> pinyin;
  final Value<String?> pinyinPlain;
  final Value<String?> pinyinInitials;
  final Value<String> english;
  final Value<String?> myanmar;
  final Value<String?> exampleSentenceCn;
  final Value<String?> exampleSentencePinyin;
  final Value<String?> exampleSentenceEng;
  final Value<String?> exampleSentenceMy;
  final Value<String?> relatedWords;
  final Value<String?> favoritedAt;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.chinese = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.pinyinPlain = const Value.absent(),
    this.pinyinInitials = const Value.absent(),
    this.english = const Value.absent(),
    this.myanmar = const Value.absent(),
    this.exampleSentenceCn = const Value.absent(),
    this.exampleSentencePinyin = const Value.absent(),
    this.exampleSentenceEng = const Value.absent(),
    this.exampleSentenceMy = const Value.absent(),
    this.relatedWords = const Value.absent(),
    this.favoritedAt = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required int hskLevel,
    required String chinese,
    required String pinyin,
    this.pinyinPlain = const Value.absent(),
    this.pinyinInitials = const Value.absent(),
    required String english,
    this.myanmar = const Value.absent(),
    this.exampleSentenceCn = const Value.absent(),
    this.exampleSentencePinyin = const Value.absent(),
    this.exampleSentenceEng = const Value.absent(),
    this.exampleSentenceMy = const Value.absent(),
    this.relatedWords = const Value.absent(),
    this.favoritedAt = const Value.absent(),
  }) : hskLevel = Value(hskLevel),
       chinese = Value(chinese),
       pinyin = Value(pinyin),
       english = Value(english);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<int>? hskLevel,
    Expression<String>? chinese,
    Expression<String>? pinyin,
    Expression<String>? pinyinPlain,
    Expression<String>? pinyinInitials,
    Expression<String>? english,
    Expression<String>? myanmar,
    Expression<String>? exampleSentenceCn,
    Expression<String>? exampleSentencePinyin,
    Expression<String>? exampleSentenceEng,
    Expression<String>? exampleSentenceMy,
    Expression<String>? relatedWords,
    Expression<String>? favoritedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (chinese != null) 'chinese': chinese,
      if (pinyin != null) 'pinyin': pinyin,
      if (pinyinPlain != null) 'pinyin_plain': pinyinPlain,
      if (pinyinInitials != null) 'pinyin_initials': pinyinInitials,
      if (english != null) 'english': english,
      if (myanmar != null) 'myanmar': myanmar,
      if (exampleSentenceCn != null) 'example_sentence_cn': exampleSentenceCn,
      if (exampleSentencePinyin != null)
        'example_sentence_pinyin': exampleSentencePinyin,
      if (exampleSentenceEng != null)
        'example_sentence_eng': exampleSentenceEng,
      if (exampleSentenceMy != null) 'example_sentence_my': exampleSentenceMy,
      if (relatedWords != null) 'related_words': relatedWords,
      if (favoritedAt != null) 'favorited_at': favoritedAt,
    });
  }

  WordsCompanion copyWith({
    Value<int>? id,
    Value<int>? hskLevel,
    Value<String>? chinese,
    Value<String>? pinyin,
    Value<String?>? pinyinPlain,
    Value<String?>? pinyinInitials,
    Value<String>? english,
    Value<String?>? myanmar,
    Value<String?>? exampleSentenceCn,
    Value<String?>? exampleSentencePinyin,
    Value<String?>? exampleSentenceEng,
    Value<String?>? exampleSentenceMy,
    Value<String?>? relatedWords,
    Value<String?>? favoritedAt,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      hskLevel: hskLevel ?? this.hskLevel,
      chinese: chinese ?? this.chinese,
      pinyin: pinyin ?? this.pinyin,
      pinyinPlain: pinyinPlain ?? this.pinyinPlain,
      pinyinInitials: pinyinInitials ?? this.pinyinInitials,
      english: english ?? this.english,
      myanmar: myanmar ?? this.myanmar,
      exampleSentenceCn: exampleSentenceCn ?? this.exampleSentenceCn,
      exampleSentencePinyin:
          exampleSentencePinyin ?? this.exampleSentencePinyin,
      exampleSentenceEng: exampleSentenceEng ?? this.exampleSentenceEng,
      exampleSentenceMy: exampleSentenceMy ?? this.exampleSentenceMy,
      relatedWords: relatedWords ?? this.relatedWords,
      favoritedAt: favoritedAt ?? this.favoritedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<int>(hskLevel.value);
    }
    if (chinese.present) {
      map['chinese'] = Variable<String>(chinese.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (pinyinPlain.present) {
      map['pinyin_plain'] = Variable<String>(pinyinPlain.value);
    }
    if (pinyinInitials.present) {
      map['pinyin_initials'] = Variable<String>(pinyinInitials.value);
    }
    if (english.present) {
      map['english'] = Variable<String>(english.value);
    }
    if (myanmar.present) {
      map['myanmar'] = Variable<String>(myanmar.value);
    }
    if (exampleSentenceCn.present) {
      map['example_sentence_cn'] = Variable<String>(exampleSentenceCn.value);
    }
    if (exampleSentencePinyin.present) {
      map['example_sentence_pinyin'] = Variable<String>(
        exampleSentencePinyin.value,
      );
    }
    if (exampleSentenceEng.present) {
      map['example_sentence_eng'] = Variable<String>(exampleSentenceEng.value);
    }
    if (exampleSentenceMy.present) {
      map['example_sentence_my'] = Variable<String>(exampleSentenceMy.value);
    }
    if (relatedWords.present) {
      map['related_words'] = Variable<String>(relatedWords.value);
    }
    if (favoritedAt.present) {
      map['favorited_at'] = Variable<String>(favoritedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('chinese: $chinese, ')
          ..write('pinyin: $pinyin, ')
          ..write('pinyinPlain: $pinyinPlain, ')
          ..write('pinyinInitials: $pinyinInitials, ')
          ..write('english: $english, ')
          ..write('myanmar: $myanmar, ')
          ..write('exampleSentenceCn: $exampleSentenceCn, ')
          ..write('exampleSentencePinyin: $exampleSentencePinyin, ')
          ..write('exampleSentenceEng: $exampleSentenceEng, ')
          ..write('exampleSentenceMy: $exampleSentenceMy, ')
          ..write('relatedWords: $relatedWords, ')
          ..write('favoritedAt: $favoritedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [words];
}

typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      required int hskLevel,
      required String chinese,
      required String pinyin,
      Value<String?> pinyinPlain,
      Value<String?> pinyinInitials,
      required String english,
      Value<String?> myanmar,
      Value<String?> exampleSentenceCn,
      Value<String?> exampleSentencePinyin,
      Value<String?> exampleSentenceEng,
      Value<String?> exampleSentenceMy,
      Value<String?> relatedWords,
      Value<String?> favoritedAt,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      Value<int> hskLevel,
      Value<String> chinese,
      Value<String> pinyin,
      Value<String?> pinyinPlain,
      Value<String?> pinyinInitials,
      Value<String> english,
      Value<String?> myanmar,
      Value<String?> exampleSentenceCn,
      Value<String?> exampleSentencePinyin,
      Value<String?> exampleSentenceEng,
      Value<String?> exampleSentenceMy,
      Value<String?> relatedWords,
      Value<String?> favoritedAt,
    });

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hskLevel => $composableBuilder(
    column: $table.hskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinyinInitials => $composableBuilder(
    column: $table.pinyinInitials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get myanmar => $composableBuilder(
    column: $table.myanmar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentenceCn => $composableBuilder(
    column: $table.exampleSentenceCn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentencePinyin => $composableBuilder(
    column: $table.exampleSentencePinyin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentenceEng => $composableBuilder(
    column: $table.exampleSentenceEng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentenceMy => $composableBuilder(
    column: $table.exampleSentenceMy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedWords => $composableBuilder(
    column: $table.relatedWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoritedAt => $composableBuilder(
    column: $table.favoritedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hskLevel => $composableBuilder(
    column: $table.hskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chinese => $composableBuilder(
    column: $table.chinese,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyin => $composableBuilder(
    column: $table.pinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinyinInitials => $composableBuilder(
    column: $table.pinyinInitials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get english => $composableBuilder(
    column: $table.english,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get myanmar => $composableBuilder(
    column: $table.myanmar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentenceCn => $composableBuilder(
    column: $table.exampleSentenceCn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentencePinyin => $composableBuilder(
    column: $table.exampleSentencePinyin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentenceEng => $composableBuilder(
    column: $table.exampleSentenceEng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentenceMy => $composableBuilder(
    column: $table.exampleSentenceMy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedWords => $composableBuilder(
    column: $table.relatedWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoritedAt => $composableBuilder(
    column: $table.favoritedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);

  GeneratedColumn<String> get chinese =>
      $composableBuilder(column: $table.chinese, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get pinyinPlain => $composableBuilder(
    column: $table.pinyinPlain,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinyinInitials => $composableBuilder(
    column: $table.pinyinInitials,
    builder: (column) => column,
  );

  GeneratedColumn<String> get english =>
      $composableBuilder(column: $table.english, builder: (column) => column);

  GeneratedColumn<String> get myanmar =>
      $composableBuilder(column: $table.myanmar, builder: (column) => column);

  GeneratedColumn<String> get exampleSentenceCn => $composableBuilder(
    column: $table.exampleSentenceCn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentencePinyin => $composableBuilder(
    column: $table.exampleSentencePinyin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentenceEng => $composableBuilder(
    column: $table.exampleSentenceEng,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentenceMy => $composableBuilder(
    column: $table.exampleSentenceMy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedWords => $composableBuilder(
    column: $table.relatedWords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoritedAt => $composableBuilder(
    column: $table.favoritedAt,
    builder: (column) => column,
  );
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
          Word,
          PrefetchHooks Function()
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hskLevel = const Value.absent(),
                Value<String> chinese = const Value.absent(),
                Value<String> pinyin = const Value.absent(),
                Value<String?> pinyinPlain = const Value.absent(),
                Value<String?> pinyinInitials = const Value.absent(),
                Value<String> english = const Value.absent(),
                Value<String?> myanmar = const Value.absent(),
                Value<String?> exampleSentenceCn = const Value.absent(),
                Value<String?> exampleSentencePinyin = const Value.absent(),
                Value<String?> exampleSentenceEng = const Value.absent(),
                Value<String?> exampleSentenceMy = const Value.absent(),
                Value<String?> relatedWords = const Value.absent(),
                Value<String?> favoritedAt = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                hskLevel: hskLevel,
                chinese: chinese,
                pinyin: pinyin,
                pinyinPlain: pinyinPlain,
                pinyinInitials: pinyinInitials,
                english: english,
                myanmar: myanmar,
                exampleSentenceCn: exampleSentenceCn,
                exampleSentencePinyin: exampleSentencePinyin,
                exampleSentenceEng: exampleSentenceEng,
                exampleSentenceMy: exampleSentenceMy,
                relatedWords: relatedWords,
                favoritedAt: favoritedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hskLevel,
                required String chinese,
                required String pinyin,
                Value<String?> pinyinPlain = const Value.absent(),
                Value<String?> pinyinInitials = const Value.absent(),
                required String english,
                Value<String?> myanmar = const Value.absent(),
                Value<String?> exampleSentenceCn = const Value.absent(),
                Value<String?> exampleSentencePinyin = const Value.absent(),
                Value<String?> exampleSentenceEng = const Value.absent(),
                Value<String?> exampleSentenceMy = const Value.absent(),
                Value<String?> relatedWords = const Value.absent(),
                Value<String?> favoritedAt = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                hskLevel: hskLevel,
                chinese: chinese,
                pinyin: pinyin,
                pinyinPlain: pinyinPlain,
                pinyinInitials: pinyinInitials,
                english: english,
                myanmar: myanmar,
                exampleSentenceCn: exampleSentenceCn,
                exampleSentencePinyin: exampleSentencePinyin,
                exampleSentenceEng: exampleSentenceEng,
                exampleSentenceMy: exampleSentenceMy,
                relatedWords: relatedWords,
                favoritedAt: favoritedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
      Word,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
}
