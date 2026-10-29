import 'package:flutter/material.dart';

/// Barra de ações padronizada para células de tabelas (ex: Editar e Excluir).
class TableActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String editTooltip;
  final String deleteTooltip;
  final List<Widget> extraActions;

  const TableActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.editTooltip = 'Editar',
    this.deleteTooltip = 'Excluir',
    this.extraActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...extraActions,
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            tooltip: editTooltip,
            color: Colors.blue.shade700,
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: deleteTooltip,
            color: Colors.red.shade700,
            onPressed: onDelete,
          ),
      ],
    );
  }
}

