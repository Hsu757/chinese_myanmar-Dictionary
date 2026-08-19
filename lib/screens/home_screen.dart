import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_drawer.dart';
import 'word_detail_screen.dart';
import '../main.dart';
import '../database.dart';
import '../database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  List<Word> searchResult = [];
  List<Word> historyWords = [];
  List<Word> favoriteWords = [];
  Word? chineseOfTheDay;

  bool isLoading = false;
  Timer? _debounce;
  int _searchId = 0;

  bool _showAllHistory = false;
  bool _showAllFavorites = false;

  @override
  void initState() {
    super.initState();
    settingsController.addListener(_updateUI);
    _loadHomeData();
  }

  @override
  void dispose() {
    settingsController.removeListener(_updateUI);
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _updateUI() {
    if (mounted) _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final history = await DatabaseHelper.instance.getHistory();
    final favorites = await DatabaseHelper.instance.getFavorites();

    Word? randomFav;
    if (favorites.isNotEmpty) {
      final random = Random();
      randomFav = favorites[random.nextInt(favorites.length)];
    }

    if (!mounted) return;
    setState(() {
      historyWords = history; 
      favoriteWords = favorites;
      chineseOfTheDay = randomFav;
    });
  }

  // မြန်မာစာအပါအဝင် စာသားများ တိကျစွာ ရှာဖွေနိုင်ရေး Clean ပြုလုပ်ပြီး ရှာဖွေသည့် Function
  Future<void> searchWord(String keyword) async {
    final currentSearch = ++_searchId;

    // မြန်မာ Keyboard များမှ ပါလာတတ်သော Invisible Characters (\u200B, \uFEFF) နှင့် အပို Space များ သန့်စင်ခြင်း
    final cleanKeyword = keyword
        .replaceAll(RegExp(r'[\u200B\uFEFF]'), '')
        .trim();

    if (cleanKeyword.isEmpty) {
      if (!mounted) return;
      setState(() { searchResult = []; isLoading = false; });
      return;
    }
    setState(() { isLoading = true; });
    final results = await DatabaseHelper.instance.searchWords(cleanKeyword);
    if (currentSearch != _searchId) return;
    if (!mounted) return;
    setState(() { searchResult = results; isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';

    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color accentColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color cardBg = isDark
        ? const Color(0xFF2C1A0E).withValues(alpha: 0.85)
        : const Color(0xFFF5EBE6).withValues(alpha: 0.85);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: bgColor,
          image: DecorationImage(
            image: const AssetImage('assets/images/bg_photo.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            opacity: isDark ? 0.15 : 0.25,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => AppDrawer.open(context), icon: Icon(Icons.menu, color: textColor)),
                    Expanded(
                      child: SearchBarWidget(
                        controller: searchController,
                        onSubmitted: searchWord,
                        onChanged: (val) {
                          _debounce?.cancel();
                          _debounce = Timer(const Duration(milliseconds: 300), () => searchWord(val));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: searchController.text.isNotEmpty
                      ? _buildSearchResults(isDark, isMyanmar, textColor, subTextColor, accentColor, cardBg)
                      : _buildHomeSections(isMyanmar, textColor, subTextColor, accentColor, cardBg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeSections(bool isMyanmar, Color textColor, Color subTextColor, Color accentColor, Color cardBg) {
    final Color mutedBottomColor = subTextColor.withValues(alpha: 0.65);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (historyWords.isNotEmpty) ...[
            _buildSectionHeader("🔥 Quick Search", () => setState(() => _showAllHistory = !_showAllHistory), _showAllHistory, historyWords.length),
            _buildHorizontalList(historyWords, cardBg, textColor, subTextColor),
            const SizedBox(height: 20),
          ],

          if (chineseOfTheDay != null) ...[
            const Text("📅 Chinese of the Day", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _navigateToDetail(chineseOfTheDay!),
                  child: Stack(
                    children: [
                      Positioned.fill(child: Image.asset('assets/images/card_photo.png', fit: BoxFit.cover)),
                      Container(color: Colors.black.withValues(alpha: 0.5)),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chineseOfTheDay!.chinese, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            Text(chineseOfTheDay!.pinyin, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text(
                              isMyanmar 
                                  ? ((chineseOfTheDay!.myanmar != null && chineseOfTheDay!.myanmar!.trim().isNotEmpty) ? chineseOfTheDay!.myanmar! : chineseOfTheDay!.english)
                                  : chineseOfTheDay!.english, 
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (favoriteWords.isNotEmpty) ...[
            _buildSectionHeader("⭐ Popular Words", () => setState(() => _showAllFavorites = !_showAllFavorites), _showAllFavorites, favoriteWords.length),
            _buildHorizontalList(favoriteWords, cardBg, textColor, subTextColor),
            const SizedBox(height: 20),
          ],
          
          const SizedBox(height: 42),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_rounded, 
                  size: 53, 
                  color: mutedBottomColor,
                ),
                const SizedBox(height: 6),
                Text(
                  isMyanmar ? "တရုတ် - မြန်မာ\nအဘိဓာန်" : "Chinese - Myanmar\nDictionary", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontSize: 20 * settingsController.fontSizeScale, 
                    fontWeight: FontWeight.w500, 
                    color: mutedBottomColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Word> items, Color cardBg, Color textColor, Color subTextColor) {
    bool isHistoryList = items == historyWords;
    bool showAll = isHistoryList ? _showAllHistory : _showAllFavorites;
    
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: showAll ? items.length : (items.length > 5 ? 5 : items.length),
        itemBuilder: (context, index) {
          return _buildWordChip(items[index], cardBg, textColor, subTextColor);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, bool isExpanded, int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (length > 5)
          TextButton(onPressed: onTap, child: Text(isExpanded ? "Show Less" : "See More")),
      ],
    );
  }

  Widget _buildWordChip(Word word, Color cardBg, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 100,
      child: Card(
        color: cardBg,
        child: InkWell(
          onTap: () => _navigateToDetail(word),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(word.chinese, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)), 
                Text(word.pinyin, style: TextStyle(fontSize: 12, color: subTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search Result ကို Card ပုံစံဖြင့် ပြသပေးသော Widget
  Widget _buildSearchResults(bool isDark, bool isMyanmar, Color textColor, Color subTextColor, Color accentColor, Color cardBg) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    
    if (searchResult.isEmpty) {
      return Center(
        child: Text(
          isMyanmar ? "ရှာဖွေမှု ရလဒ် မရှိပါ" : "No results found",
          style: TextStyle(color: subTextColor, fontSize: 16 * settingsController.fontSizeScale),
        ),
      );
    }

    final Color borderColor = isDark ? const Color(0xFF3D2314) : const Color(0xFFE6D5C3);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final word = searchResult[index];
        final String meaning = isMyanmar 
            ? ((word.myanmar != null && word.myanmar!.trim().isNotEmpty) ? word.myanmar! : word.english) 
            : word.english;

        return Card(
          color: cardBg,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: borderColor, width: 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () => _navigateToDetail(word),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.chinese,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 22 * settingsController.fontSizeScale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (word.pinyin.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            word.pinyin,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 14 * settingsController.fontSizeScale,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          meaning,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16 * settingsController.fontSizeScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: subTextColor,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetail(Word word) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WordDetailScreen(word: word, searchText: searchController.text))).then((_) => _loadHomeData());
  }
}