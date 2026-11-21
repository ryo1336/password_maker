import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_maker/services/password_generator.dart';
import 'package:password_maker/utils/clipboard.dart';
import 'package:password_maker/widgets/history_tile.dart';
import 'package:password_maker/widgets/password_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 履歴の最大保持件数(超えた分は古い順に削除)
  static const maxHistoryCount = 30;

  /// 上部(パスワード・オプション)を固定し履歴だけをスクロールさせるのに必要な
  /// 本文領域の高さ(論理ピクセル、文字倍率 1.0 時)。
  /// 上部の高さ + 履歴を数件表示できる余白を目安にしている。
  /// これ未満の高さでは画面全体をスクロールさせ、はみ出しを防ぐ。
  static const minHeightForFixedLayout = 760.0;

  final _generator = PasswordGenerator();

  String passwordText = '';
  // 数字フラグ
  bool includeNumbers = false;
  // 特殊文字フラグ
  bool includeSpecialChars = false;

  // 履歴リスト
  List<String> historyList = [];

  @override
  void initState() {
    super.initState();
    passwordText = _generate();
  }

  String _generate() => _generator.generate(includeNumbers, includeSpecialChars);

  void _refreshPassword() {
    setState(() {
      // 前に生成したパスワードを履歴の先頭に追加
      historyList.insert(0, passwordText);
      if (historyList.length > maxHistoryCount) {
        historyList.removeRange(maxHistoryCount, historyList.length);
      }
      // 新しいパスワードを表示
      passwordText = _generate();
    });
  }

  void _onGeneratePressed() {
    HapticFeedback.selectionClick();
    _refreshPassword();
  }

  /// オプション変更後、すぐに結果を確認できるよう再生成する
  void _updateOptions(VoidCallback update) {
    setState(update);
    _refreshPassword();
  }

  Widget _buildPasswordDisplay(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.key_rounded, size: 18, color: colors.onPrimaryContainer),
              const SizedBox(width: 6),
              // 狭い画面・大きな文字サイズでは文字数表示を優先し、見出しを省略する
              Expanded(
                child: Text(
                  '生成されたパスワード',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 文字数
              if (passwordText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${passwordText.length}文字',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // パスワード
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween(begin: 0.96, end: 1.0).animate(animation),
                    child: child,
                  ),
                ),
                child: PasswordText(
                  key: ValueKey(passwordText),
                  password: passwordText,
                  selectable: true,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // リフレッシュボタン
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _onGeneratePressed,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('再生成'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.surface.withValues(alpha: 0.7),
                    foregroundColor: colors.onSurface,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // コピーボタン
              Expanded(
                child: FilledButton.icon(
                  onPressed: passwordText.isEmpty
                      ? null
                      : () => copyToClipboard(context, passwordText),
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('コピー'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {Widget? trailing}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 28, 0, 8),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.pin_outlined),
            title: const Text('数字を含める'),
            subtitle: const Text('末尾に 0〜9 を1文字追加'),
            value: includeNumbers,
            onChanged: (value) => _updateOptions(() => includeNumbers = value),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          SwitchListTile(
            secondary: const Icon(Icons.tag_rounded),
            title: const Text('記号を含める'),
            subtitle: const Text('末尾に !@#\$ などを1文字追加'),
            value: includeSpecialChars,
            onChanged: (value) => _updateOptions(() => includeSpecialChars = value),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(BuildContext context) {
    return _buildSectionHeader(
      context,
      historyList.isEmpty ? '履歴' : '履歴(${historyList.length})',
      trailing: historyList.isEmpty
          ? null
          : TextButton(
              onPressed: () => setState(historyList.clear),
              child: const Text('すべて消去'),
            ),
    );
  }

  Widget _buildHistoryEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            size: 40,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: 8),
          Text(
            '再生成すると、以前のパスワードがここに残ります',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 履歴一覧
  /// [scrollable] が true のときは履歴だけを独立してスクロールさせる(固定レイアウト用)
  Widget _buildHistoryList(BuildContext context, {required bool scrollable}) {
    if (historyList.isEmpty) {
      final empty = _buildHistoryEmpty(context);
      return scrollable ? SingleChildScrollView(child: empty) : empty;
    }

    final list = ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: scrollable ? null : const NeverScrollableScrollPhysics(),
      itemCount: historyList.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (_, i) => HistoryTile(password: historyList[i]),
    );

    // 件数が少ないときはカードを中身の高さに合わせ、上寄せで表示する
    return scrollable
        ? Align(alignment: Alignment.topCenter, child: Card(child: list))
        : Card(child: list);
  }

  /// 十分な高さがあるとき: パスワード・オプションを固定し、履歴だけをスクロール
  Widget _buildFixedLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPasswordDisplay(context),
          _buildSectionHeader(context, 'オプション'),
          _buildOptions(context),
          _buildHistoryHeader(context),
          Expanded(child: _buildHistoryList(context, scrollable: true)),
        ],
      ),
    );
  }

  /// 高さが足りないとき(横画面・小型端末・大きな文字サイズ): 画面全体をスクロール
  Widget _buildScrollableLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        _buildPasswordDisplay(context),
        _buildSectionHeader(context, 'オプション'),
        _buildOptions(context),
        _buildHistoryHeader(context),
        _buildHistoryList(context, scrollable: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('英単語パスワードメーカー'),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            // タブレット・横画面でも間延びしないよう幅を制限
            constraints: const BoxConstraints(maxWidth: 560),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 文字サイズ設定が大きいほど上部の高さも増えるため、しきい値も拡大する
                final requiredHeight =
                    MediaQuery.textScalerOf(context).scale(minHeightForFixedLayout);
                return constraints.maxHeight >= requiredHeight
                    ? _buildFixedLayout(context)
                    : _buildScrollableLayout(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
