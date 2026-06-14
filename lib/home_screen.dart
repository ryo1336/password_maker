import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_maker/password_generator.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String passwordText = '';
  // 数字フラグ
  bool includeNumbers = false;
  // 特殊文字フラグ
  bool includeSpecialChars = false;
  // カスタムフラグ
  bool includeCustom = false;

  @override
  void initState() {
    super.initState();
    _refreshPassword();
  }

  Future<void> _refreshPassword() async {
    final pw = await PasswordGenerator().generate(includeNumbers, includeSpecialChars, includeCustom);
    if (mounted) {
      setState(() {
        passwordText = pw;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Divider(),
        const SizedBox(height: 20), // スペース
        // パスワード
        Text(passwordText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // スペース
        const SizedBox(height: 20),
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
              onPressed: _refreshPassword,
            ),
          ],
        ),
        const SizedBox(height: 20), // スペース
        const Divider(),
        SwitchListTile(
          title: const Text('数字を含める'),
          value: includeNumbers,
          onChanged: (value) {
            setState(() {
              // カスタムとの併用不可
              includeCustom = false;
              includeNumbers = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('記号を含める'),
          value: includeSpecialChars,
          onChanged: (value) {
            setState(() {
              // カスタムとの併用不可
              includeCustom = false;
              includeSpecialChars = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('カスタム文字列を含める'),
          value: includeCustom,
          onChanged: (value) {
            setState(() {
              // 数字、記号との併用不可
              includeNumbers = false;
              includeSpecialChars = false;
              includeCustom = value;
            });
          },
        ),
        const Divider(),
      ],
    );
  }
}