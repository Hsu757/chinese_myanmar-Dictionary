import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'database_helper.dart'; // 🌟 Database helper ကို ပြန် import လုပ်ထားပါသည်
import 'settings_controller.dart';
import 'screens/home_screen.dart'; // 🌟 HomeScreen ကို ပြန် import လုပ်ထားပါသည် (folder နာမည် screen သို့မဟုတ် screens စစ်ပေးပါ)

final SettingsController settingsController = SettingsController();

void main() async {
  // 1. Flutter Binding ကို စတင်ပါ
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); 
  
  // 2. Native Splash Screen ကို အရင်ဆုံး ထိန်းထားပါမည် (Logo လေးနှင့် Splash Screen ပေါ်နေမည်)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // 3. Database ကို Splash Screen ပေါ်နေစဉ် နောက်ကွယ်တွင် သွင်းပါမည်
  await DatabaseHelper.instance.importCsvToDatabase();
  
  // 4. Database သွင်းပြီးသွားပါက Native Splash ကို ဖျောက်လိုက်ပါမည်
  FlutterNativeSplash.remove();
  
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
      home: const HomeScreen(), // 🌟 SplashScreen အစား HomeScreen ကို တိုက်ရိုက်ခေါ်ပေးထားပါသည်
    );
  }
}