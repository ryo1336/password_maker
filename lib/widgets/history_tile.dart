import 'package:flutter/material.dart';
import 'package:password_maker/utils/clipboard.dart';
import 'package:password_maker/widgets/password_text.dart';

class HistoryTile extends StatelessWidget {
  final String password;

  const HistoryTile({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      title: PasswordText(
        password: password,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      // コピーアイコン
      trailing: IconButton(
        icon: const Icon(Icons.copy_rounded, size: 20),
        tooltip: 'コピー',
        onPressed: () => copyToClipboard(context, password),
      ),
      onTap: () => copyToClipboard(context, password),
    );
  }
}
