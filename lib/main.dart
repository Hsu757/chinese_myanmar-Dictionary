import 'package:flutter/material.dart';
import 'database_helper.dart'; 
import 'settings_controller.dart';
import 'screens/home_screen.dart';

final SettingsController settingsController = SettingsController();

void main() async {
  // Database အလုပ်လုပ်ဖို့အတွက် အဓိက လိုအပ်တဲ့ အပိုင်း
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // // 1. Database ကို စတင် Initialize လုပ်ပါ
  // await DatabaseHelper.instance.initDatabase();
  
  // 2. CSV ထဲက Data တွေကို Database ထဲ သွင်းပါ
  await DatabaseHelper.instance.importCsvToDatabase();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    settingsController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinese Myanmar Dictionary',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 1,
        ),
      ),
      themeMode: settingsController.themeMode,
      builder: (context, child) {
        final double systemScale = MediaQuery.of(context).textScaler.scale(1.0);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(systemScale * settingsController.fontSizeScale),
          ),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}