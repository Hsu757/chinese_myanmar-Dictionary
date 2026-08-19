import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _favoritesKey = 'favorites_words';
  static const String _historyKey = 'history_words';

  // ================= FAVORITES SECTION =================

  /// အကြိုက်ဆုံး သိမ်းဆည်းထားသော စာလုံးများ ယူခြင်း
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(_favoritesKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return decodedList
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Error getting favorites: $e");
      await clearFavorites();
    }
    return [];
  }

  /// စာလုံးတစ်လုံး Favorite ထဲ ရှိ/မရှိ စစ်ခြင်း
  static Future<bool> isFavorite(Map<String, dynamic> word) async {
    if (!word.containsKey('chinese')) return false;
    final favorites = await getFavorites();
    return favorites.any((item) => item['chinese'] == word['chinese']);
  }

  /// Favorite ထည့်ခြင်း / ဖြုတ်ခြင်း
  static Future<void> toggleFavorite(Map<String, dynamic> word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> favorites = await getFavorites();

      bool exists = favorites.any((item) => item['chinese'] == word['chinese']);
      if (exists) {
        favorites.removeWhere((item) => item['chinese'] == word['chinese']);
      } else {
        Map<String, dynamic> wordWithDate = Map<String, dynamic>.from(word);
        final nowIso = DateTime.now().toIso8601String();
        
        // 💡 ရက်စွဲ Key (၂) မျိုးလုံးဖြင့် သိမ်းဆည်းပေးခြင်း
        wordWithDate['favoritedAt'] = nowIso;
        wordWithDate['timestamp'] = nowIso;
        
        favorites.insert(0, wordWithDate);
      }

      String encodedData = jsonEncode(favorites);
      await prefs.setString(_favoritesKey, encodedData);
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    }
  }

  /// Favorite အားလုံး ရှင်းလင်းခြင်း
  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  // ================= HISTORY SECTION =================

  /// ရှာဖွေခဲ့ဖူးသော History စာရင်း ယူခြင်း
  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(_historyKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return decodedList
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Error getting history: $e");
      await clearHistory();
    }
    return [];
  }

  /// Search History ထဲသို့ စကားလုံးသစ် ထည့်သွင်းခြင်း
  static Future<void> addToHistory(Map<String, dynamic> word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> history = await getHistory();

      // ထပ်နေသော စကားလုံးရှိပါက အရင်ဖျက်မည်
      history.removeWhere((item) => item['chinese'] == word['chinese']);

      Map<String, dynamic> wordWithDate = Map<String, dynamic>.from(word);
      final nowIso = DateTime.now().toIso8601String();

      // 💡 searchedAt နှင့် timestamp (၂) မျိုးလုံး ထည့်သွင်းပေးထား၍ HistoryScreen တွင် ရက်စွဲ မပျောက်တော့ပါ
      wordWithDate['searchedAt'] = nowIso;
      wordWithDate['timestamp'] = nowIso;

      // ရှာဖွေခဲ့သော စကားလုံးကို ထိပ်ဆုံးသို့ ထည့်မည်
      history.insert(0, wordWithDate);

      // စကားလုံး ၁၀၀ ထက်ပိုပါက အဟောင်းများကို ဖြတ်ထုတ်မည်
      if (history.length > 100) {
        history = history.sublist(0, 100);
      }

      String encodedData = jsonEncode(history);
      await prefs.setString(_historyKey, encodedData);
    } catch (e) {
      debugPrint("Error adding to history: $e");
    }
  }

  /// History ထဲမှ စကားလုံးတစ်လုံးချင်းစီ ဖျက်ခြင်း
  static Future<void> removeFromHistory(Map<String, dynamic> word) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> history = await getHistory();
      history.removeWhere((item) => item['chinese'] == word['chinese']);
      await prefs.setString(_historyKey, jsonEncode(history));
    } catch (e) {
      debugPrint("Error removing single history item: $e");
    }
  }

  /// History အားလုံး ရှင်းလင်းခြင်း
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}