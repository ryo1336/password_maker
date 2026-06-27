import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryTile extends StatelessWidget {
  final String password;

  const HistoryTile({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(password)
        ),
        // コピーアイコン
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: password),
            );

            if (!context.mounted) return;
          },
        ),
      ],
    );
  }
} 