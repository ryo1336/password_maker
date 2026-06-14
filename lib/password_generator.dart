import 'dart:convert';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

class PasswordGenerator {
  static const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  Future<String> generate(bool includeNumbers, bool includeSpecialChars, bool includeCustom) async {
    final pair = WordPair.random();
    String password = pair.asPascalCase;

    if (includeNumbers) password += getNumbers();
    if (includeSpecialChars) password += getSpecialChars();
    if (includeCustom) password += await getCustom();

    return password;
  }

  String getNumbers() {
    return Random().nextInt(10).toString();
  }

  String getSpecialChars() {
    return specialChars[Random().nextInt(specialChars.length)];
  }

  Future<String> getCustom() async {
    final jsonString = await rootBundle.loadString('assets/custom_config.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    return data['custom'] as String? ?? '';
  }
}
