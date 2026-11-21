import 'package:flutter/material.dart';

/// 等幅フォントのフォールバック
const monospaceFonts = ['Menlo', 'Roboto Mono', 'Courier New', 'monospace'];

/// 英字・数字・記号を色分けしてパスワードを表示する
class PasswordText extends StatelessWidget {
  final String password;
  final TextStyle? style;
  final bool selectable;

  const PasswordText({
    super.key,
    required this.password,
    this.style,
    this.selectable = false,
  });

  static final _digit = RegExp(r'[0-9]');
  static final _letter = RegExp(r'[A-Za-z]');

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final base = (style ?? DefaultTextStyle.of(context).style).copyWith(
      fontFamily: 'monospace',
      fontFamilyFallback: monospaceFonts,
    );

    final span = TextSpan(
      style: base,
      children: [
        for (final char in password.characters)
          TextSpan(
            text: char,
            style: _letter.hasMatch(char)
                ? null
                : TextStyle(
                    color: _digit.hasMatch(char) ? colors.primary : colors.tertiary,
                  ),
          ),
      ],
    );

    return selectable
        ? SelectableText.rich(span, textAlign: TextAlign.center)
        : Text.rich(span, overflow: TextOverflow.ellipsis);
  }
}
