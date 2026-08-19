import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../storage_service.dart';
import '../main.dart';
import '../database.dart';

class WordDetailScreen extends StatefulWidget {
  final Word word;
  final String searchText;

  const WordDetailScreen({
    super.key,
    required this.word,
    required this.searchText,
  });

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  bool isFavorite = false;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
    _checkFavoriteStatus();
    _saveToHistory();
    settingsController.addListener(_onSettingsChanged);
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("zh-CN");
      await _flutterTts.awaitSpeakCompletion(true);
      await _applyTtsSettings();
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> _applyTtsSettings() async {
    double speed = settingsController.ttsSpeed;

    if (kIsWeb) {
      await _flutterTts.setSpeechRate(speed.clamp(0.1, 2.0));
    } else {
      await _flutterTts.setSpeechRate((speed * 0.5).clamp(0.1, 1.0));
    }

    await _flutterTts.setVolume(settingsController.ttsVolume);
  }

  Future<void> _speak(String text) async {
    final String cleanText = text.trim();
    if (cleanText.isEmpty) return;

    try {
      await _flutterTts.stop();
      await _flutterTts.setLanguage("zh-CN");
      await _applyTtsSettings();
      await _flutterTts.speak(cleanText);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _checkFavoriteStatus() async {
    bool fav = await StorageService.isFavorite(widget.word.toJson());
    if (mounted) setState(() => isFavorite = fav);
  }

  Future<void> _saveToHistory() async {
    await StorageService.addToHistory(widget.word.toJson());
  }

  Future<void> _toggleFavorite() async {
    await StorageService.toggleFavorite(widget.word.toJson());
    if (mounted) setState(() => isFavorite = !isFavorite);
  }

  // Data စာသားများကို မခွဲထုတ်မီ သန့်စင်ပေးသည့် Helper Function
  String _sanitizeText(String? input) {
    if (input == null) return "";
    return input
        .replaceAll(r'\n', '\n') // Literal '\n' စာသားကို Newline အစစ် ပြောင်းမည်
        .replaceAll('\r', '') // Windows Carriage Return ကို ဖျက်မည်
        .replaceAll(RegExp(r'[\u200B\uFEFF]'), '') // မမြင်နိုင်သော Invisible Characters ဖျက်မည်
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';
    final scale = settingsController.fontSizeScale;

    // Chocolate Theme Palette
    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color cardBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFFF5EBE6);
    final Color accentColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color borderColor = isDark ? const Color(0xFF3D2314) : const Color(0xFFE6D5C3);
    final Color searchBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFFE6D5C3);

    final String my = widget.word.myanmar ?? "";
    final String en = widget.word.english;
    final String activeMeaning = isMyanmar ? (my.isNotEmpty ? my : en) : en;

    // ဥပမာဝါကျများ ပုဒ်ဖြတ် ခွဲထုတ်ရန် RegExp (| ၊ ｜ ၊ ; ၊ ； ၊ Enter)
    final RegExp sentenceSplitter = RegExp(r'[|\uFF5C\n\r;；]+');

    // ဆက်စပ်ဝေါဟာရများ ပုဒ်ဖြတ် ခွဲထုတ်ရန် RegExp (, ၊ ， ၊ 、 ၊ | ၊ ｜ ၊ ; ၊ ； ၊ / ၊ Enter)
    final RegExp relatedSplitter = RegExp(r'[,，、|\uFF5C\n\r;；/]+');

    List<String> cnSentences = _sanitizeText(widget.word.exampleSentenceCn)
        .split(sentenceSplitter)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<String> pySentences = _sanitizeText(widget.word.exampleSentencePinyin)
        .split(sentenceSplitter)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String rawTr = isMyanmar
        ? ((widget.word.exampleSentenceMy ?? "").isNotEmpty ? widget.word.exampleSentenceMy! : (widget.word.exampleSentenceEng ?? ""))
        : ((widget.word.exampleSentenceEng ?? "").isNotEmpty ? widget.word.exampleSentenceEng! : (widget.word.exampleSentenceMy ?? ""));

    List<String> trSentences = _sanitizeText(rawTr)
        .split(sentenceSplitter)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<String> relatedWordsList = _sanitizeText(widget.word.relatedWords)
        .split(relatedSplitter)
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: searchBg,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: accentColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.searchText.isNotEmpty ? widget.searchText : "search",
                                  style: TextStyle(fontSize: 16 * scale, color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Header
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                word: widget.word,
                isFavorite: isFavorite,
                onFavoriteToggle: _toggleFavorite,
                onBackTap: () => Navigator.pop(context),
                onAudioTap: () => _speak(widget.word.chinese),
              ),
            ),

            // Content Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("❏ ", style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.bold, color: textColor)),
                        Expanded(
                          child: Text(
                            activeMeaning,
                            style: TextStyle(fontSize: 18 * scale, height: 1.4, color: subTextColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Example Sentences
                    if (cnSentences.isNotEmpty) ...[
                      Text(
                        isMyanmar ? "❏ ဥပမာ ဝါကျ -" : "❏ Example Sentence -",
                        style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(cnSentences.length, (index) {
                        final cn = cnSentences[index];
                        final py = index < pySentences.length ? pySentences[index] : '';
                        final tr = index < trSentences.length ? trSentences[index] : '';

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      cn,
                                      style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.bold, color: textColor),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.volume_up, color: accentColor, size: 22 * scale),
                                    onPressed: () => _speak(cn),
                                  ),
                                ],
                              ),
                              if (py.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  py,
                                  style: TextStyle(
                                    fontSize: 15 * scale,
                                    color: accentColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              if (tr.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  tr,
                                  style: TextStyle(fontSize: 16 * scale, color: subTextColor),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    // Related Words (တစ်ကြောင်းချင်းစီ ပြသခြင်း)
                    if (relatedWordsList.isNotEmpty) ...[
                      Text(
                        isMyanmar ? "❏ ဆက်စပ် ဝေါဟာရများ -" : "❏ Related Words -",
                        style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 10),
                      ...relatedWordsList.map(
                        (wordItem) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            wordItem,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              color: accentColor,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Word word;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBackTap;
  final VoidCallback onAudioTap;

  _StickyHeaderDelegate({
    required this.word,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBackTap,
    required this.onAudioTap,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isCollapsed = shrinkOffset > 40;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = settingsController.fontSizeScale;

    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color chineseColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color pinyinColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color iconColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color accentColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color favActiveColor = isDark ? const Color(0xFFE6B89C) : const Color(0xFF5C3D2E);

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: isCollapsed
          ? Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back, color: iconColor), onPressed: onBackTap),
                Expanded(
                  child: Text(
                    word.chinese,
                    style: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.bold, color: chineseColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(icon: Icon(Icons.volume_up, color: accentColor, size: 22), onPressed: onAudioTap),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? favActiveColor : accentColor,
                    size: 22,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ],
            )
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    word.chinese,
                    style: TextStyle(fontSize: 34 * scale, fontWeight: FontWeight.bold, color: chineseColor),
                  ),
                  if (word.pinyin.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      word.pinyin,
                      style: TextStyle(fontSize: 15 * scale, color: pinyinColor, fontStyle: FontStyle.italic),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up, color: accentColor, size: 24 * scale),
                        onPressed: onAudioTap,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? favActiveColor : accentColor,
                          size: 24 * scale,
                        ),
                        onPressed: onFavoriteToggle,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  double get maxExtent => 135.0;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.word != word || oldDelegate.isFavorite != isFavorite;
  }
}