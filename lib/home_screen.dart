import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_maker/password_generator.dart';
import 'histrory_tile.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String passwordText = '';
  String previousPassword = '';
  // 数字フラグ
  bool includeNumbers = false;
  // 特殊文字フラグ
  bool includeSpecialChars = false;
  // カスタムフラグ
  bool includeCustom = false;

  // 履歴リスト
  List<String> historyList = [];

  @override
  void initState() {
    super.initState();
    _refreshPassword();
  }

  Future<void> _refreshPassword() async {
    // 以前のパスワードを保存
    previousPassword = passwordText;

    // 新規のパスワードを生成
    final pw = await PasswordGenerator().generate(includeNumbers, includeSpecialChars, includeCustom);

    if (mounted) {
      setState(() {
        // 新しいパスワードを表示
        passwordText = pw;
        // 前に生成したパスワードがあれば履歴に追加
        if(previousPassword.isNotEmpty) {
          historyList.insert(0, previousPassword);
        }
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
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
        const Divider(height: 20),
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
        const Divider(height: 20),
        Expanded(
          child: ListView.builder(            
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              return HistoryTile(
                password: historyList[index],
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8)
          ),
        ),
      ],
    );
  }
}