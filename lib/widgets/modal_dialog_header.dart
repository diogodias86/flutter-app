import 'package:flutter/material.dart';

/// Cabeçalho padronizado para caixas de diálogo modais com ícone, título e botão fechar.
class ModalDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onClose;

  const ModalDialogHeader({
    super.key,
    required this.icon,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose ?? () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}

