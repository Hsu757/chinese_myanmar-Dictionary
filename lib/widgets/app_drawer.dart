import 'package:flutter/material.dart';
import '../screens/favorites_screen.dart';
import '../screens/history_screen.dart';
import '../screens/about_screen.dart';
import '../main.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  /// Drawer ကို ဖြေးဖြေးချင်း ဖွင့်ပေးမည့် Static Function
  static void open(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.7),
        transitionDuration: const Duration(milliseconds: 400), // မူလ Duration အတိုင်း
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              child: const AppDrawer(),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
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
    final Color headerBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFF6F4E37);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color accentColor = isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37);
    final Color dividerColor = isDark ? const Color(0xFF3D2314) : const Color(0xFFE6D5C3);

    return Drawer(
      backgroundColor: bgColor,
      elevation: 16,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28.0),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(color: headerBg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isMyanmar ? "တရုတ် - မြန်မာ\nအဘိဓာန်" : "Chinese - Myanmar\nDictionary",
                  style: TextStyle(
                    color: const Color(0xFFFDFBF7),
                    fontSize: 20 * settingsController.fontSizeScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ================= ၁။ NAVIGATION MENU =================
          ListTile(
            leading: Icon(Icons.favorite, color: textColor),
            title: Text(
              isMyanmar ? "အနှစ်သက်ဆုံးများ" : "Favourites",
              style: TextStyle(color: textColor, fontSize: 15 * settingsController.fontSizeScale,fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: textColor),
            title: Text(
              isMyanmar ? "မှတ်တမ်း" : "History",
              style: TextStyle(color: textColor, fontSize: 15 * settingsController.fontSizeScale,fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
            },
          ),

          Divider(color: dividerColor),

          // ================= ၂။ SETTINGS SECTION =================
          
          // ဘာသာစကား (Language)
          ListTile(
            leading: Icon(Icons.language, color: accentColor),
            title: Text(
              isMyanmar ? "ဘာသာစကား" : "Language",
              style: TextStyle(color: textColor, fontSize: 14 * settingsController.fontSizeScale, fontWeight: FontWeight.w600),
            ),
            trailing: DropdownButton<String>(
              dropdownColor: isDark ? const Color(0xFF2C1A0E) : const Color(0xFFF5EBE6),
              value: settingsController.language,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'my', child: Text("မြန်မာ")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (val) {
                if (val != null) settingsController.updateLanguage(val);
              },
            ),
          ),

          // အမှောင် အသွင်အပြင် (Dark Mode)
          SwitchListTile(
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: accentColor),
            title: Text(
              isMyanmar ? "အမှောင် အသွင်အပြင်" : "Dark Mode",
              style: TextStyle(color: textColor, fontSize: 14 * settingsController.fontSizeScale, fontWeight: FontWeight.w600),
            ),
            value: settingsController.themeMode == ThemeMode.dark,
            activeTrackColor: accentColor, // 💡 activeColor အစား activeTrackColor သို့ ပြောင်းထားပါသည်
            onChanged: (bool value) {
              settingsController.updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),

          // စာလုံး အရွယ်အစား (Font Size)
          ExpansionTile(
            leading: Icon(Icons.format_size, color: accentColor),
            title: Text(
              isMyanmar ? "စာလုံး အရွယ်အစား" : "Font Size",
              style: TextStyle(color: textColor, fontSize: 14 * settingsController.fontSizeScale, fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isMyanmar ? "သေး" : "Small", style: TextStyle(color: subTextColor, fontSize: 11 * settingsController.fontSizeScale)),
                        Text(isMyanmar ? "ပုံမှန်" : "Normal", style: TextStyle(color: subTextColor, fontSize: 12 * settingsController.fontSizeScale, fontWeight: FontWeight.bold)),
                        Text(isMyanmar ? "ကြီး" : "Large", style: TextStyle(color: subTextColor, fontSize: 13 * settingsController.fontSizeScale)),
                      ],
                    ),
                    Slider(
                      value: settingsController.fontSizeScale,
                      min: 0.85,
                      max: 1.15,
                      divisions: 2,
                      activeColor: accentColor,
                      inactiveColor: dividerColor,
                      onChanged: (double val) => settingsController.updateFontSizeScale(val),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // အသံ အတိုးအလျှော့ (Audio Volume)
          ExpansionTile(
            leading: Icon(
              settingsController.ttsVolume == 0
                  ? Icons.volume_off
                  : (settingsController.ttsVolume < 0.5 ? Icons.volume_down : Icons.volume_up),
              color: accentColor,
            ),
            title: Text(
              isMyanmar ? "အသံ အတိုးအလျှော့" : "Audio Volume",
              style: TextStyle(color: textColor, fontSize: 14 * settingsController.fontSizeScale, fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              "${(settingsController.ttsVolume * 100).round()}%",
              style: TextStyle(color: subTextColor, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Slider(
                  value: settingsController.ttsVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: accentColor,
                  inactiveColor: dividerColor,
                  onChanged: (double val) => settingsController.updateTtsVolume(val),
                ),
              ),
            ],
          ),

          // အသံ ထွက်နှုန်း (Speech Speed)
          ExpansionTile(
            leading: Icon(Icons.speed, color: accentColor),
            title: Text(
              isMyanmar ? "အသံ ထွက်နှုန်း" : "Speech Speed",
              style: TextStyle(color: textColor, fontSize: 14 * settingsController.fontSizeScale, fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              "${settingsController.ttsSpeed.toStringAsFixed(1)}x",
              style: TextStyle(color: subTextColor, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Slider(
                  value: settingsController.ttsSpeed.clamp(0.1, 2.0),
                  min: 0.1,
                  max: 2.0,
                  activeColor: accentColor,
                  inactiveColor: dividerColor,
                  onChanged: (double val) => settingsController.updateTtsSpeed(val),
                ),
              ),
            ],
          ),

          Divider(color: dividerColor),

          // ================= ၃။ ABOUT MENU =================
          ListTile(
            leading: Icon(Icons.info, color: textColor),
            title: Text(
              isMyanmar ? "အကြောင်းအရာ" : "About",
              style: TextStyle(color: textColor, fontSize: 15 * settingsController.fontSizeScale,fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
            },
          ),
        ],
      ),
    );
  }
}