import 'package:flutter/material.dart';
import '../storage_service.dart';
import 'word_detail_screen.dart';
import '../main.dart';
import '../database.dart'; // မူလ model လမ်းကြောင်းအစား drift database.dart ကို ချိတ်ပေးထားသည်

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Word> favoriteWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    settingsController.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadFavorites() async {
    final List<Map<String, dynamic>> favMaps = await StorageService.getFavorites();
    // Drift မှ generate လုပ်ပေးသော fromJson ကို သုံး၍ Word object သို့ ပြောင်းသည်
    final List<Word> words = favMaps.map((map) => Word.fromJson(map)).toList();
    
    if (!mounted) return;
    setState(() {
      favoriteWords = words;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(Word word) async {
    // Drift ၏ toJson ကို အသုံးပြုသည်
    await StorageService.toggleFavorite(word.toJson());
    _loadFavorites();
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(isoString);
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} (${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')})";
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1009) : const Color(0xFF2C1A0E),
        // 🔽 AppBar ထဲရှိ Back မြားနှင့် အခြား Icon များ အဖြူရောင်ဖြစ်စေရန်
        iconTheme: const IconThemeData(
          color: Color(0xFFFDFBF7),
        ),
        title: Text(
          isMyanmar ? "နှစ်သက်သော စကားလုံးများ" : "Favorite Words",
          style: TextStyle(
            color: const Color(0xFFFDFBF7), 
            fontSize: 20 * settingsController.fontSizeScale
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteWords.isEmpty
              ? Center(child: Text(isMyanmar ? "သိမ်းဆည်းထားသော စကားလုံး မရှိသေးပါ" : "No favorite words saved yet"))
              : ListView.builder(
                  itemCount: favoriteWords.length,
                  itemBuilder: (context, index) {
                    final item = favoriteWords[index];
                    
                    // Database column name 'english' နှင့် ကိုက်ညီစေရန် ပြင်ထားသည်
                    final String activeMeaning = isMyanmar 
                        ? (item.myanmar ?? item.english) 
                        : item.english;
                    
                    final String formattedDate = _formatDateTime(item.favoritedAt);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: Text(
                          item.chinese, 
                          style: TextStyle(
                            fontSize: 20 * settingsController.fontSizeScale, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeMeaning, 
                              style: TextStyle(fontSize: 15 * settingsController.fontSizeScale)
                            ),
                            if (formattedDate.isNotEmpty)
                              Text(
                                formattedDate, 
                                style: TextStyle(
                                  fontSize: 11 * settingsController.fontSizeScale, 
                                  color: isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63)
                                )
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Color(0xFF2C1A0E)),
                          onPressed: () => _removeFavorite(item),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(
                                word: item, 
                                searchText: item.chinese
                              ),
                            ),
                          ).then((_) => _loadFavorites());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}