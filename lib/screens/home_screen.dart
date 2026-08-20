import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_drawer.dart';
import 'word_detail_screen.dart';
import '../main.dart';
import '../database.dart';
import '../database_helper.dart';
import '../category_data.dart';
import '../category_screens.dart';

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

  bool isLoading = false;
  Timer? _debounce;
  int _searchId = 0;

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

    if (!mounted) return;
    setState(() {
      historyWords = history;
      favoriteWords = favorites;
    });
  }

  Future<void> searchWord(String keyword) async {
    final currentSearch = ++_searchId;
    if (keyword.isEmpty) {
      if (!mounted) return;
      setState(() {
        searchResult = [];
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final results = await DatabaseHelper.instance.searchWords(keyword);
    if (currentSearch != _searchId) return;
    if (!mounted) return;
    setState(() {
      searchResult = results;
      isLoading = false;
    });
  }

  void _triggerQuickSearch(String keyword) {
    searchController.text = keyword;
    searchWord(keyword);
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
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: Icon(Icons.menu, color: textColor),
                    ),
                    Expanded(
                      child: SearchBarWidget(
                        controller: searchController,
                        onSubmitted: searchWord,
                        onChanged: (val) {
                          _debounce?.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 300),
                            () => searchWord(val),
                          );
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (historyWords.isNotEmpty) ...[
            Text(
              "⚡ Quick Search",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: historyWords
                  .take(5)
                  .map((w) => ActionChip(
                        label: Text(w.chinese),
                        onPressed: () => _triggerQuickSearch(w.chinese),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (favoriteWords.isNotEmpty) ...[
            Text(
              "⭐ Popular Words",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: favoriteWords
                  .take(5)
                  .map((w) => ActionChip(
                        label: Text(w.chinese),
                        onPressed: () => _triggerQuickSearch(w.chinese),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
          _buildCategorySection(isMyanmar, textColor, accentColor, cardBg),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategorySection(bool isMyanmar, Color textColor, Color accentColor, Color cardBg) {
    final displayCategories = appCategories.take(4).toList();
    final List<Color> defaultColors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMyanmar ? "အမျိုးအစားများ" : "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllCategoriesScreen()),
                );
              },
              child: Text(
                isMyanmar ? "အားလုံးကြည့်ရန်" : "View All",
                style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final cat = displayCategories[index];
            final color = defaultColors[index % defaultColors.length];

            return Card(
              color: cardBg,
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 3,
              clipBehavior: Clip.antiAlias, // ပုံ ကတ်အစွန်းထွက်မသွားစေရန်
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: cat)),
                  );
                },
                child: SizedBox(
                  height: 120, // ကတ်၏ အမြင့်
                  child: Stack(
                    children: [
                      // 🌟 ၁။ နောက်ခံ ပုံ (Full Image Background)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.4), // ပုံ မထည့်မီ ပြသမည့် အရောင်
                            /* နောက်ပိုင်း ပုံထည့်ပါက အောက်ပါ လိုင်း ၃ လိုင်းကို un-comment လုပ်ပါ:
                            image: DecorationImage(
                              image: AssetImage('assets/images/${cat.titleEn.toLowerCase()}.png'),
                              fit: BoxFit.cover,
                            ),
                            */
                          ),
                        ),
                      ),

                      // 🌟 ၂။ စာသား ထင်ရှားစေရန် Gradient အုပ်ပေးခြင်း
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.75), // စာသားအောက်တွင် အမည်းရောင်သန်းစေရန်
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 🌟 ၃။ ပုံပေါ်တွင် စာသား ထည့်သွင်းခြင်း
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isMyanmar ? cat.titleMy : cat.titleEn,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // ပုံပေါ် ရောက်မည်ဖြစ်၍ စာသားကို အဖြူရောင်ထားပါသည်
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${cat.words.length} ${isMyanmar ? 'လုံး' : 'words'}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults(bool isDark, bool isMyanmar, Color textColor, Color subTextColor, Color accentColor, Color cardBg) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (searchResult.isEmpty) return Center(child: Text(isMyanmar ? "ရှာဖွေမှု ရလဒ် မရှိပါ" : "No results found"));

    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final word = searchResult[index];
        return Card(
          color: cardBg,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            onTap: () => _navigateToDetail(word),
            title: Text(word.chinese, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(isMyanmar ? (word.myanmar ?? word.english) : word.english),
          ),
        );
      },
    );
  }

  void _navigateToDetail(Word word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailScreen(word: word, searchText: searchController.text),
      ),
    ).then((_) => _loadHomeData());
  }
}