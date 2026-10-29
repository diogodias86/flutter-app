import 'package:flutter/material.dart';

/// Container de layout para páginas de backoffice desktop, com padding e fundo padronizados.
class PageContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const PageContainer({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

