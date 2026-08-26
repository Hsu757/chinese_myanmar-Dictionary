import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';
import 'category_data.dart'; // Data ဖိုင်ကို ချိတ်ရန်
import '../main.dart'; // settingsController ပါဝင်သော ဖိုင်

// 🌟 Chocolate Theme အရောင်များ
class ChocolateTheme {
  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFFDFBF7);     
  static const Color cardBgLight = Color(0xFFF5EBE6);         
  static const Color textDark = Color(0xFF2C1A0E);   
  static const Color milkChocolate = Color(0xFF6F4E37);   

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF1A1009);     
  static const Color cardBgDark = Color(0xFF2C1A0E);         
  static const Color textLight = Color(0xFFFDFBF7);          
}

// 🌟 ၁။ Category အားလုံးပြမည့် Screen (၁ ကတ် ၁ Row + Full Background Banner ပုံစံ)
class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> defaultColors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.brown,
      Colors.teal,
    ];

    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        final bool isDark = settingsController.themeMode == ThemeMode.dark;
        final bool isEnglish = settingsController.language == 'en';
        final double scale = settingsController.fontSizeScale;

        return Scaffold(
          backgroundColor: isDark ? ChocolateTheme.backgroundDark : ChocolateTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF2C1A0E) : const Color(0xFF6F4E37),
            title: Text(
              isEnglish ? "All Categories" : "အမျိုးအစားအားလုံး", 
              style: TextStyle(
                color: const Color(0xFFFDFBF7),
                fontSize: 20 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFFFDFBF7)),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appCategories.length,
            itemBuilder: (context, index) {
              final cat = appCategories[index];
              final color = defaultColors[index % defaultColors.length];

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: isDark ? 0 : 3,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: isDark ? const Color(0xFF3D2314) : Colors.transparent),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: cat)),
                  ),
                  child: SizedBox(
                    height: 120,
                    child: Stack(
                      children: [
                        // ၁။ ပုံ သို့မဟုတ် နောက်ခံ အရောင် (Full Background)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: color.withValues(alpha:0.4),
                              /* နောက်ပိုင်း ပုံထည့်ပါက အောက်ပါ လိုင်းကို un-comment လုပ်ပါ:
                              image: DecorationImage(
                                image: AssetImage('assets/images/${cat.titleEn.toLowerCase()}.png'),
                                fit: BoxFit.cover,
                              ),
                              */
                            ),
                          ),
                        ),

                        // ၂။ စာသား ပေါ်လွင်စေရန် အနက်ရောင် Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha:0.75),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ၃။ ပုံပေါ်တွင် စာသား ထည့်သွင်းခြင်း
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
                                        cat.emoji, // 👈 Data ဖိုင်ထဲက emoji ကို ဒီမှာ ပြန်ခေါ်သုံးလိုက်တာပါ
                                        style: TextStyle(fontSize: 24 * scale),
                                      ),
                                      const SizedBox(height: 8),
                                  Text(
                                    isEnglish ? cat.titleEn : cat.titleMy,
                                    style: TextStyle(
                                      fontSize: 18 * scale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // const SizedBox(height: 4),
                                  // Text(
                                  //   "${cat.words.length} ${isEnglish ? 'words' : 'လုံး'}",
                                  //   style: TextStyle(
                                  //     fontSize: 12 * scale,
                                  //     color: Colors.white.withValues(alpha: 0.8),
                                  //   ),
                                  // ),
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
        );
      },
    );
  }
}

// 🌟 ၂။ Category နှိပ်လျှင် အတွင်းရှိ စာလုံးများပြမည့် Screen (တိရစ္ဆာန်များ စသည်)
class CategoryDetailScreen extends StatefulWidget {
  final CategoryItem category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  int? _flippedIndex; 

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (context, child) {
        final bool isDark = settingsController.themeMode == ThemeMode.dark;
        final bool isEnglish = settingsController.language == 'en';
        final double scale = settingsController.fontSizeScale;

        return Scaffold(
          backgroundColor: isDark ? ChocolateTheme.backgroundDark : ChocolateTheme.backgroundLight,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF2C1A0E) : const Color(0xFF6F4E37),
            title: Text(
              isEnglish ? widget.category.titleEn : widget.category.titleMy, 
              style: TextStyle(
                color: const Color(0xFFFDFBF7),
                fontSize: 20 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFFFDFBF7)),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          
              crossAxisSpacing: 12,       
              mainAxisSpacing: 12,        
              mainAxisExtent: 110,        
            ),
            itemCount: widget.category.words.length,
            itemBuilder: (context, index) {
              return FlipWordCard(
                word: widget.category.words[index],
                accentColor: isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37),
                isFlipped: _flippedIndex == index,
                isEnglish: isEnglish,
                isDarkMode: isDark,
                fontSizeScale: scale,
                onFlipChanged: (isFlipped) {
                  setState(() {
                    if (isFlipped) {
                      _flippedIndex = index; 
                    } else {
                      if (_flippedIndex == index) {
                        _flippedIndex = null; 
                      }
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}

// 🌟 ၃။ Flashcard (ကတ်လှည့်ခြင်း + အသံထွက် + စုတ်ချက်ခလုတ်)
class FlipWordCard extends StatefulWidget {
  final Map<String, String> word;
  final Color accentColor;
  final bool isFlipped;
  final bool isEnglish;
  final bool isDarkMode;
  final double fontSizeScale;
  final ValueChanged<bool> onFlipChanged;

  const FlipWordCard({
    super.key, 
    required this.word, 
    required this.accentColor,
    required this.isFlipped,
    required this.isEnglish,
    required this.isDarkMode,
    required this.fontSizeScale,
    required this.onFlipChanged,
  });

  @override
  State<FlipWordCard> createState() => _FlipWordCardState();
}

class _FlipWordCardState extends State<FlipWordCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    if (widget.isFlipped) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipWordCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
        _speakChinese(widget.word['chinese'] ?? ''); 
      } else {
        _controller.reverse();
        _flutterTts.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakChinese(String text) async {
    await _flutterTts.setLanguage("zh-CN");
    await _flutterTts.setVolume(settingsController.ttsVolume);
    await _flutterTts.setSpeechRate(settingsController.ttsSpeed);
    await _flutterTts.speak(text);
  }

  void _showStrokeDialog(BuildContext context, String chinese) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? ChocolateTheme.cardBgDark : ChocolateTheme.cardBgLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEnglish ? "Stroke Order" : "စုတ်ချက်အစဉ်လိုက်", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: widget.isDarkMode ? ChocolateTheme.textLight : ChocolateTheme.textDark, 
                fontSize: 16 * widget.fontSizeScale,
              ),
            ),
            const SizedBox(height: 12),
            StrokeOrderWidget(chineseChar: chinese, isDarkMode: widget.isDarkMode),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text(
                widget.isEnglish ? "Close" : "ပိတ်ရန်", 
                style: TextStyle(color: widget.accentColor, fontSize: 14 * widget.fontSizeScale),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String chinese = widget.word['chinese'] ?? '';
    final String pinyin = widget.word['pinyin'] ?? '';
    
    final String meaning = widget.isEnglish 
        ? (widget.word['english'] ?? widget.word['myanmar'] ?? '') 
        : (widget.word['myanmar'] ?? widget.word['english'] ?? '');

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * pi;
        final isBackVisible = angle >= pi / 2;

        return Transform(
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              widget.onFlipChanged(!widget.isFlipped);
            },
            child: SizedBox(
              height: 110,
              child: Card(
                color: widget.isDarkMode ? ChocolateTheme.cardBgDark : ChocolateTheme.cardBgLight,
                elevation: widget.isDarkMode ? 0 : 1,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: widget.isDarkMode ? const Color(0xFF3D2314) : Colors.transparent),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: isBackVisible
                      ? Transform(
                          alignment: Alignment.center, 
                          transform: Matrix4.identity()..rotateY(pi), 
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                chinese, 
                                style: TextStyle(
                                  fontSize: 18 * widget.fontSizeScale, 
                                  fontWeight: FontWeight.bold, 
                                  color: widget.isDarkMode ? ChocolateTheme.textLight : ChocolateTheme.textDark,
                                ), 
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                pinyin, 
                                style: TextStyle(
                                  fontSize: 11 * widget.fontSizeScale, 
                                  color: widget.accentColor,
                                ), 
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 24,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.accentColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  ),
                                  onPressed: () => _showStrokeDialog(context, chinese),
                                  child: Text(
                                    widget.isEnglish ? "Stroke" : "စုတ်ချက်", 
                                    style: TextStyle(fontSize: 10 * widget.fontSizeScale),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            meaning, 
                            style: TextStyle(
                              fontSize: 15 * widget.fontSizeScale, 
                              fontWeight: FontWeight.bold, 
                              color: widget.isDarkMode ? ChocolateTheme.textLight : ChocolateTheme.textDark,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// 🌟 ၄။ Stroke Order Widget (HanziWriter Animation)
class StrokeOrderWidget extends StatefulWidget {
  final String chineseChar;
  final bool isDarkMode;
  const StrokeOrderWidget({super.key, required this.chineseChar, required this.isDarkMode});

  @override
  State<StrokeOrderWidget> createState() => _StrokeOrderWidgetState();
}

class _StrokeOrderWidgetState extends State<StrokeOrderWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final String chars = widget.chineseChar;
    const int boxSize = 100;
    final String strokeColor = widget.isDarkMode ? '#F7F3EE' : '#2C1A0E';
    final String outlineColor = widget.isDarkMode ? '#55443B' : '#E6D5C3';

    final htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.jsdelivr.net/npm/hanzi-writer@3.5.0/dist/hanzi-writer.min.js"></script>
        <style>
          body { 
            margin: 0; 
            padding: 0; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            background: transparent; 
          }
          .container { 
            display: flex; 
            justify-content: center;
            align-items: center;
          }
          .char-box { 
            width: ${boxSize}px; 
            height: ${boxSize}px; 
          }
        </style>
      </head>
      <body>
        <div class="container" id="main-container"></div>
        <script>
          const rawChars = "$chars";
          const chars = Array.from(rawChars);
          const container = document.getElementById('main-container');
          
          async function playCarousel() {
            if (chars.length === 0) return;
            
            while (true) {
              for (let i = 0; i < chars.length; i++) {
                container.innerHTML = ''; 
                const div = document.createElement('div');
                div.id = 'current-char';
                div.className = 'char-box';
                container.appendChild(div);
                
                try {
                  const writer = HanziWriter.create('current-char', chars[i], {
                    width: $boxSize, 
                    height: $boxSize, 
                    padding: 5, 
                    showOutline: true,
                    strokeAnimationSpeed: 1, 
                    delayBetweenStrokes: 400,
                    strokeColor: '$strokeColor',
                    outlineColor: '$outlineColor'
                  });
                  await writer.animateCharacter(); 
                } catch (e) {
                  console.log(e);
                }
                await new Promise(resolve => setTimeout(resolve, 800)); 
              }
              await new Promise(resolve => setTimeout(resolve, 2000)); 
            }
          }

          playCarousel();
        </script>
      </body>
      </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: WebViewWidget(controller: _controller),
    );
  }
}