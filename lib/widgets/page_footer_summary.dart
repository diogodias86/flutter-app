import 'package:flutter/material.dart';

/// Rodapé padronizado para telas com tabelas de dados e resumos estatísticos.
class PageFooterSummary extends StatelessWidget {
  final String summaryText;
  final String statusText;

  const PageFooterSummary({
    super.key,
    required this.summaryText,
    this.statusText = 'Atualizado em tempo real',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            summaryText,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          statusText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

