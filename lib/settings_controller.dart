import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  // Theme Settings (Light / Dark / System)
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Font Size Scale (0.9 = Small, 1.0 = Normal, 1.2 = Large)
  double _fontSizeScale = 1.0;
  double get fontSizeScale => _fontSizeScale;

  // App Language ('my' = Myanmar, 'en' = English)
  String _language = 'my';
  String get language => _language;

  // Audio TTS Settings
  double _ttsSpeed = 0.5; // 0.1 to 1.0
  double get ttsSpeed => _ttsSpeed;

  double _ttsVolume = 1.0; // 0.0 to 1.0
  double get ttsVolume => _ttsVolume;

  SettingsController() {
    _loadSettings();
  }

  // ဖုန်းထဲ သိမ်းထားသော Settings များကို ပြန်ဖတ်ခြင်း
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    _fontSizeScale = prefs.getDouble('fontSizeScale') ?? 1.0;
    _language = prefs.getString('language') ?? 'my';
    _ttsSpeed = prefs.getDouble('ttsSpeed') ?? 0.5;
    _ttsVolume = prefs.getDouble('ttsVolume') ?? 1.0;

    notifyListeners(); // UI များသို့ ပြောင်းလဲမှု အကြောင်းကြားခြင်း
  }

  // Theme ပြောင်းရန်
  Future<void> updateThemeMode(ThemeMode newMode) async {
    _themeMode = newMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', newMode.index);
  }

  // Font Size ပြောင်းရန်
  Future<void> updateFontSizeScale(double newScale) async {
    _fontSizeScale = newScale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeScale', newScale);
  }

  // Language ပြောင်းရန်
  Future<void> updateLanguage(String newLang) async {
    _language = newLang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLang);
  }

  // TTS Speed တစ်ခုတည်း ပြောင်းရန် (Slider အတွက်)
  Future<void> updateTtsSpeed(double speed) async {
    _ttsSpeed = speed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ttsSpeed', speed);
  }

  // TTS Volume တစ်ခုတည်း ပြောင်းရန် (Slider အတွက်)
  Future<void> updateTtsVolume(double volume) async {
    _ttsVolume = volume;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ttsVolume', volume);
  }

  // TTS Speed နှင့် Volume နှစ်ခုလုံး တစ်ပြိုင်နက် ပြောင်းရန်
  Future<void> updateTtsSettings(double speed, double volume) async {
    _ttsSpeed = speed;
    _ttsVolume = volume;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ttsSpeed', speed);
    await prefs.setDouble('ttsVolume', volume);
  }
}