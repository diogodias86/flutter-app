import 'package:flutter/material.dart';

/// Card padrão da aplicação com elevação zero, bordas arredondadas e traço sutil.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: content,
    );
  }
}

