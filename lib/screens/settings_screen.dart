import 'package:flutter/material.dart';
import '../main.dart'; // settingsController ပါဝင်သော ဖိုင်

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // 💡 Settings ပြောင်းလဲမှုများကို နားထောင်ရန် Listener တပ်ထားသည်
    settingsController.addListener(_updateUI);
  }

  @override
  void dispose() {
    settingsController.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';

    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color appBarBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFF6F4E37);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color cardBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFFF5EBE6);
    final Color accentColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color borderColor = isDark ? const Color(0xFF3D2314) : Colors.transparent;
    final Color inactiveColor = isDark ? const Color(0xFF3D2314) : const Color(0xFFE6D5C3);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: isDark ? 0 : 2,
        iconTheme: const IconThemeData(color: Color(0xFFFDFBF7)),
        title: Text(
          isMyanmar ? "ဆက်တင်များ" : "Settings",
          style: TextStyle(
            color: const Color(0xFFFDFBF7),
            fontWeight: FontWeight.bold,
            fontSize: 20 * settingsController.fontSizeScale,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ================= ၁။ THEME (Light / Dark) =================
          _buildHeader(
            isMyanmar ? "အသွင်အပြင် (Theme)" : "Theme Mode",
            textColor,
          ),
          Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(
                      isMyanmar ? "အလင်း (Light)" : "Light",
                      style: TextStyle(fontSize: 14 * settingsController.fontSizeScale),
                    ),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(
                      isMyanmar ? "အမှောင် (Dark)" : "Dark",
                      style: TextStyle(fontSize: 14 * settingsController.fontSizeScale),
                    ),
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                selected: {
                  settingsController.themeMode == ThemeMode.dark
                      ? ThemeMode.dark
                      : ThemeMode.light
                },
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  settingsController.updateThemeMode(newSelection.first);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ================= ၂။ FONT SIZE =================
          _buildHeader(
            isMyanmar ? "စာလုံး အရွယ်အစား (Font Size)" : "Font Size",
            textColor,
          ),
          Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isMyanmar ? "စာလုံး သေး" : "Small",
                        style: TextStyle(color: subTextColor, fontSize: 13 * settingsController.fontSizeScale),
                      ),
                      Text(
                        isMyanmar ? "စာလုံး ပုံမှန်" : "Normal",
                        style: TextStyle(color: subTextColor, fontSize: 15 * settingsController.fontSizeScale, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isMyanmar ? "စာလုံး ကြီး" : "Large",
                        style: TextStyle(color: subTextColor, fontSize: 17 * settingsController.fontSizeScale),
                      ),
                    ],
                  ),
                  Slider(
                    value: settingsController.fontSizeScale,
                    min: 0.85,
                    max: 1.15,
                    divisions: 2,
                    activeColor: accentColor,
                    inactiveColor: inactiveColor,
                    onChanged: (double val) {
                      settingsController.updateFontSizeScale(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ================= ၃။ AUDIO VOLUME (အသံ အတိုးအလျှော့) =================
          _buildHeader(
            isMyanmar ? "အသံ အတိုးအလျှော့ (Audio Volume)" : "Audio Volume",
            textColor,
          ),
          Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    settingsController.ttsVolume == 0
                        ? Icons.volume_off
                        : (settingsController.ttsVolume < 0.5 ? Icons.volume_down : Icons.volume_up),
                    color: accentColor,
                  ),
                  Expanded(
                    child: Slider(
                      value: settingsController.ttsVolume, // 💡 settingsController ထဲမှ တိုက်ရိုက်ယူသည်
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: "${(settingsController.ttsVolume * 100).round()}%",
                      activeColor: accentColor,
                      inactiveColor: inactiveColor,
                      onChanged: (double val) {
                        settingsController.updateTtsVolume(val); // 💡 Save to SharedPreferences
                      },
                    ),
                  ),
                  Text(
                    "${(settingsController.ttsVolume * 100).round()}%",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * settingsController.fontSizeScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ================= ၄။ SPEECH SPEED (အသံ ထွက်နှုန်း အနှေးအမြန်) =================
          _buildHeader(
            isMyanmar ? "အသံ ထွက်နှုန်း (Speech Speed)" : "Speech Speed",
            textColor,
          ),
          Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.speed,
                    color: accentColor,
                  ),
                  Expanded(
                    child: Slider(
                      value: settingsController.ttsSpeed.clamp(0.1, 2.0), // 💡 settingsController ထဲမှ တိုက်ရိုက်ယူသည်
                      min: 0.1,
                      max: 2.0,
                      // divisions: 19,
                      label: "${settingsController.ttsSpeed.toStringAsFixed(1)}x",
                      activeColor: accentColor,
                      inactiveColor: inactiveColor,
                      onChanged: (double val) {
                        settingsController.updateTtsSpeed(val); // 💡 Save to SharedPreferences
                      },
                    ),
                  ),
                  Text(
                    "${settingsController.ttsSpeed.toStringAsFixed(1)}x",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * settingsController.fontSizeScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ================= ၅။ TRANSLATION LANGUAGE =================
          _buildHeader(
            isMyanmar ? "ဘာသာပြန် ဘာသာစကား (Language)" : "Translation Language",
            textColor,
          ),
          Card(
            color: cardBg,
            elevation: isDark ? 0 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'my',
                    label: Text(
                      "မြန်မာ (Myanmar)",
                      style: TextStyle(fontSize: 14 * settingsController.fontSizeScale),
                    ),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(
                      "English",
                      style: TextStyle(fontSize: 14 * settingsController.fontSizeScale),
                    ),
                  ),
                ],
                selected: {settingsController.language},
                onSelectionChanged: (Set<String> newSelection) {
                  settingsController.updateLanguage(newSelection.first);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14 * settingsController.fontSizeScale,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}