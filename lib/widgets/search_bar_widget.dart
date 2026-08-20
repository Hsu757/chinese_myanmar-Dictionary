import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1A0E) : const Color(0xFFE6D5C3), // 💡 Chocolate Box Color
        borderRadius: BorderRadius.circular(17),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: TextStyle(color: isDark ? const Color(0xFFFDFBF7) : const Color(0xFF2C1A0E)),
        decoration: InputDecoration(
          hintText: "Chinese, Pinyin,Myanmar,English...",
          hintStyle: TextStyle(color: isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63)),
          
          // 🌟 Search Icon နဲ့ စာသားကြား အကွာအဝေးကို ကပ်ပေးလိုက်သည့် အပိုင်း
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30, 
            minHeight: 48,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 6),
            child: Icon(
              Icons.search, 
              color: isDark ? const Color(0xFFD4A373) : const Color(0xFF6F4E37),
            ),
          ),
          
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: isDark ? const Color(0xFFC7B299) : const Color(0xFF8D6E63)),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}