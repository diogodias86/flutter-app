import 'package:flutter/material.dart';

/// Botão preenchido (FilledButton) com suporte integrado a indicador de progresso (loading).
class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.icon = Icons.check,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: backgroundColor,
    );

    if (icon == null && !isLoading) {
      return FilledButton(
        style: style,
        onPressed: isLoading ? null : onPressed,
        child: Text(label),
      );
    }

    return FilledButton.icon(
      style: style,
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : (icon != null ? Icon(icon, size: 18) : const SizedBox.shrink()),
      label: Text(label),
    );
  }
}

