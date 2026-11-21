import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// テキストをクリップボードにコピーし、SnackBar でフィードバックを表示する
Future<void> copyToClipboard(BuildContext context, String text) async {
  if (text.isEmpty) return;
  await Clipboard.setData(ClipboardData(text: text));
  HapticFeedback.lightImpact();
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        // 画面共有・録画中に漏れないよう、パスワード自体は表示しない
        content: const Text('パスワードをコピーしました'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}
