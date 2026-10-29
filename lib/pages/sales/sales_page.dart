import 'package:flutter/material.dart';

import '../../dtos/sales/sale_response_dto.dart';
import '../../services/customer_service.dart';
import '../../services/sale_service.dart';
import '../../utils/app_feedback.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_card.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/page_container.dart';
import '../../widgets/page_footer_summary.dart';
import '../../widgets/responsive_data_table.dart';
import '../../widgets/search_input_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/table_action_buttons.dart';
import 'sale_form_dialog.dart';

class SalesPage extends StatefulWidget {
  final SaleService saleService;
  final CustomerService customerService;

  const SalesPage({
    super.key,
    required this.saleService,
    required this.customerService,
  });

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Todos';
  List<SaleResponseDto> _sales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSales() async {
    setState(() => _isLoading = true);
    try {
      final list = await widget.saleService.getAll(
        statusFilter: _selectedStatus,
        query: _searchController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _sales = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppFeedback.showError(context, 'Erro ao carregar vendas: $e');
      }
    }
  }

  Future<void> _openCreateDialog() async {
    final created = await SaleFormDialog.show(
      context,
      saleService: widget.saleService,
      customerService: widget.customerService,
    );
    if (created == true) {
      _loadSales();
      if (mounted) {
        AppFeedback.showSuccess(context, 'Venda registrada com sucesso!');
      }
    }
  }

  Future<void> _openEditDialog(SaleResponseDto sale) async {
    final updated = await SaleFormDialog.show(
      context,
      saleService: widget.saleService,
      customerService: widget.customerService,
      saleToEdit: sale,
    );
    if (updated == true) {
      _loadSales();
      if (mounted) {
        AppFeedback.showInfo(context, 'Venda atualizada com sucesso!');
      }
    }
  }

  Future<void> _handleDelete(SaleResponseDto sale) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Excluir Venda',
      message: 'Tem certeza que deseja excluir o pedido de venda ${sale.id} '
          'no valor de ${CurrencyFormatter.format(sale.totalAmount)}?',
      confirmLabel: 'Excluir',
    );

    if (confirmed) {
      final success = await widget.saleService.delete(sale.id);
      if (success && mounted) {
        _loadSales();
        AppFeedback.showNotice(context, 'Venda ${sale.id} excluída com sucesso.');
      }
    }
  }

  void _showItemsDetail(SaleResponseDto sale) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Itens do Pedido ${sale.id}'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Cliente: ${sale.customerName}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Divider(),
                  ...sale.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.description}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(item.totalPrice),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        CurrencyFormatter.format(sale.totalAmount),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  double get _totalFaturado {
    return _sales
        .where((s) => s.status.toLowerCase() == 'faturada')
        .fold(0.0, (acc, s) => acc + s.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      children: [
        // Filter & Action Bar
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status Filter Dropdown
              SizedBox(
                width: 170,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Filtrar Status',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                    DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                    DropdownMenuItem(value: 'Faturada', child: Text('Faturada')),
                    DropdownMenuItem(value: 'Cancelada', child: Text('Cancelada')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedStatus = val);
                      _loadSales();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Search input
              Expanded(
                child: SearchInputField(
                  controller: _searchController,
                  hintText: 'Pesquisar por cliente ou código da venda...',
                  onSubmitted: (_) => _loadSales(),
                  onClear: _loadSales,
                ),
              ),
              const SizedBox(width: 12),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _loadSales,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Atualizar'),
              ),
              const SizedBox(width: 12),

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _openCreateDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nova Venda'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Main Table Card
        Expanded(
          child: ResponsiveDataTable(
            isLoading: _isLoading,
            isEmpty: _sales.isEmpty,
            emptyIcon: Icons.receipt_long_outlined,
            emptyMessage: 'Nenhuma venda encontrada',
            columns: const [
              DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Data', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Itens', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Valor Total', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _sales.map((sale) {
              return DataRow(
                cells: [
                  DataCell(Text(
                    sale.id,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )),
                  DataCell(Text(sale.customerName)),
                  DataCell(Text(DateFormatter.format(sale.saleDate))),
                  DataCell(
                    InkWell(
                      onTap: () => _showItemsDetail(sale),
                      child: Text(
                        '${sale.items.length} item(ns) 👁️',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(
                    CurrencyFormatter.format(sale.totalAmount),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(StatusBadge(status: sale.status)),
                  DataCell(
                    TableActionButtons(
                      editTooltip: 'Editar Venda',
                      deleteTooltip: 'Excluir Venda',
                      onEdit: () => _openEditDialog(sale),
                      onDelete: () => _handleDelete(sale),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Footer summary
        PageFooterSummary(
          summaryText:
              'Total de vendas: ${_sales.length} | Faturado: ${CurrencyFormatter.format(_totalFaturado)}',
        ),
      ],
    );
  }
}
