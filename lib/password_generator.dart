import 'dart:math';

import 'package:english_words/english_words.dart';

class PasswordGenerator {
  static const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  // 複数の英単語をパスカルケースで取得
  String generate(bool includeNumbers, bool includeSpecialChars, bool includeCustom) {
    // ランダムな英単語を取得
    final pair = WordPair.random();
    String password = pair.asPascalCase;

    // フラグをもとに数字、記号を追加
    // ここではフラグの組み合わせを制御しない
    if (includeNumbers) {
      password += getNumbers();
    }
    if (includeSpecialChars) {
      password += getSpecialChars();
    }
    if (includeCustom) {
      password += getCustom();
    }

    // 連結後の文字列を返却
    return password;
  }

  // ランダムな数字を取得
  String getNumbers() {
    return Random().nextInt(10).toString();
  }

  // ランダムな特殊記号を取得
  String getSpecialChars() {
    return specialChars[Random().nextInt(specialChars.length)];
  }

  // カスタム文字列を取得
  String getCustom() {
    return "";
  }
}
