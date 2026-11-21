import 'dart:math';

import 'package:english_words/english_words.dart';

class PasswordGenerator {
  static const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  String generate(bool includeNumbers, bool includeSpecialChars) {
    final pair = WordPair.random();
    String password = pair.asPascalCase;

    if (includeNumbers) password += _getNumbers();
    if (includeSpecialChars) password += _getSpecialChars();

    return password;
  }

  String _getNumbers() {
    return Random().nextInt(10).toString();
  }

  String _getSpecialChars() {
    return specialChars[Random().nextInt(specialChars.length)];
  }
}
