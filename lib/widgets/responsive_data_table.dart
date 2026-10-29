import 'package:flutter/material.dart';
import 'app_card.dart';
import 'empty_state.dart';

/// Card de tabela de dados com gerenciamento automático de carregamento,
/// estado vazio e rolagem bidirecional responsiva.
class ResponsiveDataTable extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyMessage;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double columnSpacing;

  const ResponsiveDataTable({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.columns,
    required this.rows,
    this.columnSpacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (isEmpty) {
      content = EmptyState(
        icon: emptyIcon,
        message: emptyMessage,
      );
    } else {
      content = LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ),
                  columnSpacing: columnSpacing,
                  columns: columns,
                  rows: rows,
                ),
              ),
            ),
          );
        },
      );
    }

    return AppCard(child: content);
  }
}

