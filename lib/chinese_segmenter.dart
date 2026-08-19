import 'dart:math';

class ChineseSegmenter {
  /// Forward Maximum Matching (FMM) Algorithm ဖြင့် တရုတ်စာကြောင်းကို ခွဲထုတ်ခြင်း
  static List<String> segment(
    String input, 
    Set<String> dictionaryWords, {
    int maxWordLength = 6, // Optional Parameter အဖြစ် ပြောင်းလဲထားပါသည်
  }) {
    final String text = input.replaceAll(RegExp(r'\s+'), '');
    if (text.isEmpty) return [];

    List<String> result = [];
    int start = 0;

    while (start < text.length) {
      int matchLength = 1;
      
      // စာကြောင်း မလွန်စေရန် ရနိုင်သမျှ အများဆုံး အရှည်ကို ကြိုတင် တွက်ချက်ခြင်း
      int currentMaxLen = min(maxWordLength, text.length - start);

      // အရှည်ဆုံး စကားလုံးမှ စတင်၍ ရှာမည် (Longest Match)
      for (int len = currentMaxLen; len > 1; len--) {
        String candidate = text.substring(start, start + len);
        if (dictionaryWords.contains(candidate)) {
          matchLength = len;
          break;
        }
      }

      result.add(text.substring(start, start + matchLength));
      start += matchLength;
    }

    return result;
  }
}