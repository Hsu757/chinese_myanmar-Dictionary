import 'package:flutter/material.dart';
import '../storage_service.dart';
import 'word_detail_screen.dart';
import '../main.dart';
import '../database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyList = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
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

  Future<void> _loadHistory() async {
    final List<Map<String, dynamic>> historyMaps = await StorageService.getHistory();
    
    if (!mounted) return;
    setState(() {
      historyList = historyMaps;
      isLoading = false;
    });
  }

  String _formatDateTime(dynamic rawDate) {
    if (rawDate == null) return '';
    String dateStr = rawDate.toString().trim();
    if (dateStr.isEmpty) return '';

    try {
      DateTime dt = DateTime.parse(dateStr.contains(' ') ? dateStr.replaceAll(' ', 'T') : dateStr);
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} (${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')})";
    } catch (e) {
      return dateStr;
    }
  }

  void _deleteSingleHistory(Map<String, dynamic> itemMap) {
    StorageService.removeFromHistory(itemMap).then((_) {
      _loadHistory();
    });
  }

  void _clearAllHistory() {
    final bool isMyanmar = settingsController.language == 'my';
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(isMyanmar ? "History ရှင်းလင်းရန်" : "Clear History"),
          content: Text(isMyanmar ? "ရှာဖွေခဲ့သော မှတ်တမ်းများအားလုံးကို ဖျက်ရန် သေချာပါသလား။" : "Are you sure you want to clear all search history?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(isMyanmar ? "မဖျက်ပါ" : "Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                StorageService.clearHistory().then((_) => _loadHistory());
              },
              child: Text(isMyanmar ? "ဖျက်မည်" : "Clear", style: const TextStyle(color: Color(0xFFC0392B))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';

    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF5D4037);
    final Color pinyinColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color cardBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1009) : const Color(0xFF2C1A0E),
        // 🔽 AppBar ၏ Back မြားနှင့် အခြား Icon များ အဖြူရောင်ဖြစ်စေရန်
        iconTheme: const IconThemeData(
          color: Color(0xFFFDFBF7),
        ),
        title: Text(
          isMyanmar ? "ရှာဖွေမှု မှတ်တမ်း" : "Search History",
          style: TextStyle(color: const Color(0xFFFDFBF7), fontSize: 20 * settingsController.fontSizeScale),
        ),
        actions: [
          if (historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Color(0xFFFDFBF7)),
              onPressed: _clearAllHistory,
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
              ? Center(child: Text(isMyanmar ? "ရှာဖွေခဲ့ဖူးသော မှတ်တမ်း မရှိသေးပါ" : "No search history found"))
              : ListView.builder(
                  itemCount: historyList.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final itemMap = historyList[index];
                    final Word word = Word.fromJson(itemMap);
                    
                    final formattedDate = _formatDateTime(
                      itemMap['searchedAt'] ?? itemMap['timestamp'] ?? itemMap['favoritedAt']
                    ); 
                    
                    final String activeMeaning = isMyanmar ? (word.myanmar ?? word.english) : word.english;

                    return Card(
                      color: cardBg,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: Icon(Icons.history, color: isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37)),
                        title: Row(
                          children: [
                            Text(
                              word.chinese, 
                              style: TextStyle(
                                fontSize: 18 * settingsController.fontSizeScale, 
                                fontWeight: FontWeight.bold, 
                                color: textColor
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                word.pinyin, 
                                style: TextStyle(
                                  fontSize: 14 * settingsController.fontSizeScale, 
                                  color: pinyinColor
                                ), 
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              activeMeaning, 
                              style: TextStyle(
                                fontSize: 14 * settingsController.fontSizeScale, 
                                color: subTextColor
                              ),
                            ),
                            if (formattedDate.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                formattedDate, 
                                style: TextStyle(
                                  fontSize: 12 * settingsController.fontSizeScale, 
                                  color: isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFC0392B), size: 20),
                          onPressed: () => _deleteSingleHistory(itemMap),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word, searchText: word.chinese),
                            ),
                          ).then((_) => _loadHistory());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}