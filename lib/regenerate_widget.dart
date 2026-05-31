import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:english_words/english_words.dart';

class RegenerateWidget extends StatefulWidget {

  const RegenerateWidget({
    super.key,
  });

  @override
  State<RegenerateWidget> createState() => _RegenerateWidgetState();
}

class _RegenerateWidgetState extends State<RegenerateWidget> {
  String passwordText = '';
  bool includeNumbers = false;

  @override
  void initState() {
    super.initState();
    passwordText = generatePassword(includeNumbers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 表示テキスト
        Text(passwordText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20), // スペース
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // コピーアイコン
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: passwordText),
                );

                if (!context.mounted) return;
              },
            ),
            const SizedBox(width: 30), // スペース
            // リフレッシュアイコン
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  passwordText = generatePassword(includeNumbers);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20), // スペース
        SwitchListTile(
          title: const Text('数字・記号を含める'),
          value: includeNumbers,
          onChanged: (value) {
            setState(() {
              includeNumbers = value;
            });
          },
        ),
      ],
    );
  }
  
  String generatePassword(bool includeNumbers) {
    // パスワード生成のロジックをここに実装
    final pair = WordPair.random();
    String result = pair.asPascalCase; // 例: "FlutterRocks"
    if (includeNumbers) {
      // 数字や記号を追加するロジックをここに実装
      result += "#1";
    }
    return result;
  }
}