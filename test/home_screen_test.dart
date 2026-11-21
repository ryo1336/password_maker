import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_maker/main.dart';
import 'package:password_maker/widgets/history_tile.dart';

/// 論理サイズ [size]・文字倍率 [textScale] でアプリを表示する
Future<void> pumpApp(WidgetTester tester, Size size, {double textScale = 1.0}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MainApp());
  await tester.pumpAndSettle();
}

Future<void> regenerate(WidgetTester tester, int times) async {
  for (var i = 0; i < times; i++) {
    await tester.tap(find.text('再生成'));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('縦に十分な高さがあれば、履歴だけがスクロールする', (tester) async {
    await pumpApp(tester, const Size(412, 915));
    await regenerate(tester, 15);

    final buttonY = tester.getTopLeft(find.text('再生成')).dy;
    await tester.drag(find.byType(HistoryTile).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    // パスワード欄は動かない
    expect(tester.getTopLeft(find.text('再生成')).dy, buttonY);
  });

  testWidgets('横画面では画面全体がスクロールし、はみ出さない', (tester) async {
    await pumpApp(tester, const Size(915, 412));
    await regenerate(tester, 3);

    // パスワード欄ごとスクロールする
    final optionsY = tester.getTopLeft(find.text('オプション')).dy;
    await tester.drag(find.text('オプション'), const Offset(0, -100));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('オプション')).dy, lessThan(optionsY));
  });

  testWidgets('小型端末・大きな文字サイズでもはみ出さない', (tester) async {
    await pumpApp(tester, const Size(360, 640), textScale: 1.3);
    await regenerate(tester, 3);
    // オーバーフローがあればテストフレームワークが例外として失敗させる
  });

  testWidgets('履歴は最大30件まで保持される', (tester) async {
    await pumpApp(tester, const Size(412, 915));
    await regenerate(tester, 35);

    expect(find.text('履歴(30)'), findsOneWidget);
  });
}
