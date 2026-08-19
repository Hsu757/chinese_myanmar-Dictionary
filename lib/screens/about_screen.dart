import 'package:flutter/material.dart';
import '../main.dart'; // settingsController အတွက်

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMyanmar = settingsController.language == 'my';

    // Dark Mode အလိုက် အနက်/အဖြူ သီးသန့် အရောင်သတ်မှတ်ချက်များ (Chocolate Palette)
    final Color bgColor = isDark ? const Color(0xFF1A1009) : const Color(0xFFFDFBF7);
    final Color appBarBg = isDark ? const Color(0xFF1A1009) : const Color(0xFF2C1A0E);
    final Color textColor = isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E);
    final Color subTextColor = isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63);
    final Color cardBg = isDark ? const Color(0xFF2C1A0E) : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: isDark ? 0 : 2,
        title: Text(
          isMyanmar ? "အကြောင်းအရာ" : "About App",
          style: TextStyle(
            color: const Color(0xFFFDFBF7),
            fontWeight: FontWeight.bold,
            fontSize: 20 * settingsController.fontSizeScale,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFDFBF7)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3D271D) : const Color(0xFFEDE0D4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 50,
                color: isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isMyanmar ? "တရုတ် - မြန်မာ အဘိဓာန်" : "Chinese - Myanmar Dictionary",
              style: TextStyle(
                fontSize: 20 * settingsController.fontSizeScale,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: subTextColor,
                fontSize: 14 * settingsController.fontSizeScale,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: cardBg,
              elevation: isDark ? 0 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isDark ? const Color(0xFF3D271D) : Colors.transparent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  isMyanmar
                      ? "ဤ Dictionary Application သည် တရုတ်စာ(hsk) ပညာသင်ယူနေသူများနှင့် မြန်မာဘာသာပြန် လေ့လာသူများအတွက် အလွယ်တကူ ရှာဖွေနိုင်စေရန် တည်ဆောက်ထားခြင်း ဖြစ်ပါသည်။"
                      : "This dictionary application is built for Chinese language（hsk） learners and Myanmar translators to easily search and learn words.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15 * settingsController.fontSizeScale,
                    height: 1.5,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Developed by 小兔兔",
              style: TextStyle(
                color: subTextColor,
                fontSize: 13 * settingsController.fontSizeScale,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}