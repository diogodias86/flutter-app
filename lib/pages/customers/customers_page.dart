import 'package:flutter/material.dart';

import '../../dtos/customers/customer_response_dto.dart';
import '../../services/customer_service.dart';
import '../../utils/app_feedback.dart';
import '../../widgets/app_card.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/page_container.dart';
import '../../widgets/page_footer_summary.dart';
import '../../widgets/responsive_data_table.dart';
import '../../widgets/search_input_field.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/table_action_buttons.dart';
import 'customer_form_dialog.dart';

class CustomersPage extends StatefulWidget {
  final CustomerService customerService;

  const CustomersPage({super.key, required this.customerService});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerResponseDto> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final list = await widget.customerService.getAll(
        query: _searchController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _customers = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppFeedback.showError(context, 'Erro ao carregar clientes: $e');
      }
    }
  }

  Future<void> _openCreateDialog() async {
    final created = await CustomerFormDialog.show(
      context,
      customerService: widget.customerService,
    );

    if (created == true) {
      _loadCustomers();

      if (mounted) {
        AppFeedback.showSuccess(context, 'Cliente cadastrado com sucesso!');
      }
    }
  }

  Future<void> _openEditDialog(CustomerResponseDto customer) async {
    final updated = await CustomerFormDialog.show(
      context,
      customerService: widget.customerService,
      customerToEdit: customer,
    );

    if (updated == true) {
      _loadCustomers();

      if (mounted) {
        AppFeedback.showInfo(context, 'Cliente atualizado com sucesso!');
      }
    }
  }

  Future<void> _handleDelete(CustomerResponseDto customer) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Excluir Cliente',
      message:
          'Tem certeza que deseja excluir o cliente "${customer.name}"? '
          'Esta ação não poderá ser desfeita.',
      confirmLabel: 'Excluir',
    );

    if (confirmed) {
      final success = await widget.customerService.delete(customer.id);

      if (success && mounted) {
        _loadCustomers();
        AppFeedback.showNotice(context, 'Cliente "${customer.name}" excluído.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      children: [
        // Action Bar (Desktop Filter + New Button)
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Search Input
              Expanded(
                child: SearchInputField(
                  controller: _searchController,
                  hintText: 'Pesquisar por nome, documento, e-mail ou código...',
                  onSubmitted: (_) => _loadCustomers(),
                  onClear: _loadCustomers,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _loadCustomers,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Atualizar'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _openCreateDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo Cliente'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Main Table Card
        Expanded(
          child: ResponsiveDataTable(
            isLoading: _isLoading,
            isEmpty: _customers.isEmpty,
            emptyIcon: Icons.people_outline,
            emptyMessage: 'Nenhum cliente encontrado',
            columns: const [
              DataColumn(
                label: Text(
                  'Código',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Razão Social / Nome',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Documento',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'E-mail',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Telefone',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'Ações',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: _customers.map((c) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      c.id,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(c.name)),
                  DataCell(Text(c.document)),
                  DataCell(Text(c.email)),
                  DataCell(Text(c.phone)),
                  DataCell(StatusBadge(status: c.status)),
                  DataCell(
                    TableActionButtons(
                      editTooltip: 'Editar Cliente',
                      deleteTooltip: 'Excluir Cliente',
                      onEdit: () => _openEditDialog(c),
                      onDelete: () => _handleDelete(c),
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
          summaryText: 'Total de clientes: ${_customers.length}',
        ),
      ],
    );
  }
}