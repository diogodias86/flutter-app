import 'package:flutter/material.dart';

import '../../dtos/customers/customer_response_dto.dart';
import '../../dtos/sales/create_sale_dto.dart';
import '../../dtos/sales/sale_response_dto.dart';
import '../../dtos/sales/update_sale_dto.dart';
import '../../services/customer_service.dart';
import '../../services/sale_service.dart';
import '../../utils/app_feedback.dart';
import '../../utils/app_validators.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/modal_dialog_header.dart';

class SaleFormDialog extends StatefulWidget {
  final SaleService saleService;
  final CustomerService customerService;
  final SaleResponseDto? saleToEdit;

  const SaleFormDialog({
    super.key,
    required this.saleService,
    required this.customerService,
    this.saleToEdit,
  });

  static Future<bool?> show(
    BuildContext context, {
    required SaleService saleService,
    required CustomerService customerService,
    SaleResponseDto? saleToEdit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaleFormDialog(
        saleService: saleService,
        customerService: customerService,
        saleToEdit: saleToEdit,
      ),
    );
  }

  @override
  State<SaleFormDialog> createState() => _SaleFormDialogState();
}

class _ItemEntry {
  String? id;
  final TextEditingController descController;
  final TextEditingController qtyController;
  final TextEditingController priceController;

  _ItemEntry({
    this.id,
    String description = '',
    int quantity = 1,
    double unitPrice = 0.0,
  })  : descController = TextEditingController(text: description),
        qtyController = TextEditingController(text: quantity.toString()),
        priceController = TextEditingController(
          text: unitPrice > 0 ? unitPrice.toStringAsFixed(2).replaceAll('.', ',') : '',
        );

  int get quantity => int.tryParse(qtyController.text) ?? 1;
  double get unitPrice => CurrencyFormatter.parse(priceController.text);
  double get total => quantity * unitPrice;

  void dispose() {
    descController.dispose();
    qtyController.dispose();
    priceController.dispose();
  }
}

class _SaleFormDialogState extends State<SaleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  List<CustomerResponseDto> _customers = [];
  String? _selectedCustomerId;
  late String _status;
  final List<_ItemEntry> _items = [];
  bool _isLoading = false;
  bool _isLoadingCustomers = true;

  bool get isEditing => widget.saleToEdit != null;

  @override
  void initState() {
    super.initState();
    _status = widget.saleToEdit?.status ?? 'Pendente';
    _selectedCustomerId = widget.saleToEdit?.customerId;

    if (widget.saleToEdit != null && widget.saleToEdit!.items.isNotEmpty) {
      for (final item in widget.saleToEdit!.items) {
        _items.add(_ItemEntry(
          id: item.id,
          description: item.description,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
        ));
      }
    } else {
      _items.add(_ItemEntry(description: '', quantity: 1, unitPrice: 0.0));
    }

    _loadCustomers();
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final list = await widget.customerService.getAll();
      if (mounted) {
        setState(() {
          _customers = list;
          _isLoadingCustomers = false;
          if (_selectedCustomerId == null && _customers.isNotEmpty) {
            _selectedCustomerId = _customers.first.id;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingCustomers = false);
      }
    }
  }

  double get _calculatedGrandTotal {
    return _items.fold(0.0, (acc, item) => acc + item.total);
  }

  void _addItem() {
    setState(() {
      _items.add(_ItemEntry(description: '', quantity: 1, unitPrice: 0.0));
    });
  }

  void _removeItem(int index) {
    if (_items.length <= 1) return;
    setState(() {
      final item = _items.removeAt(index);
      item.dispose();
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCustomerId == null || _selectedCustomerId!.isEmpty) {
      AppFeedback.showError(context, 'Selecione um cliente para a venda');
      return;
    }

    if (_items.isEmpty) {
      AppFeedback.showError(context, 'A venda deve conter pelo menos um item');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        final updateItems = _items.map((entry) {
          return UpdateSaleItemDto(
            id: entry.id,
            description: entry.descController.text.trim(),
            quantity: entry.quantity,
            unitPrice: entry.unitPrice,
          );
        }).toList();

        final dto = UpdateSaleDto(
          id: widget.saleToEdit!.id,
          customerId: _selectedCustomerId!,
          items: updateItems,
          status: _status,
        );

        await widget.saleService.update(dto);
      } else {
        final createItems = _items.map((entry) {
          return CreateSaleItemDto(
            description: entry.descController.text.trim(),
            quantity: entry.quantity,
            unitPrice: entry.unitPrice,
          );
        }).toList();

        final dto = CreateSaleDto(
          customerId: _selectedCustomerId!,
          items: createItems,
          status: _status,
        );

        await widget.saleService.create(dto);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, 'Erro ao salvar venda: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: ModalDialogHeader(
        icon: isEditing ? Icons.edit_calendar_rounded : Icons.add_shopping_cart_rounded,
        title: isEditing ? 'Editar Pedido de Venda' : 'Novo Pedido de Venda',
        onClose: _isLoading ? null : () => Navigator.of(context).pop(false),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 550),
        child: _isLoadingCustomers
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Customer Dropdown & Status
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedCustomerId,
                              decoration: const InputDecoration(
                                labelText: 'Cliente *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              items: _customers.map((c) {
                                return DropdownMenuItem<String>(
                                  value: c.id,
                                  child: Text('${c.name} (${c.document})'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _selectedCustomerId = val);
                              },
                              validator: AppValidators.required('Selecione um cliente'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _status,
                              decoration: const InputDecoration(
                                labelText: 'Status da Venda',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.flag_outlined),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                                DropdownMenuItem(value: 'Faturada', child: Text('Faturada')),
                                DropdownMenuItem(value: 'Cancelada', child: Text('Cancelada')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _status = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Items Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Itens da Venda',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addItem,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Adicionar Item'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Items List
                      ...List.generate(_items.length, (index) {
                        final item = _items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              // Description
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: item.descController,
                                  decoration: InputDecoration(
                                    labelText: 'Descrição do Item #${index + 1}',
                                    hintText: 'Ex: Licença ou Serviço',
                                    border: const OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  validator: AppValidators.required('Informe o item'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Qty
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: item.qtyController,
                                  decoration: const InputDecoration(
                                    labelText: 'Qtd',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                  validator: AppValidators.positiveInteger(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Unit Price
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: item.priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Preço Unit. (R\$)',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    prefixText: 'R\$ ',
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (_) => setState(() {}),
                                  validator: AppValidators.positiveCurrency(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Total preview
                              SizedBox(
                                width: 105,
                                child: Text(
                                  CurrencyFormatter.format(item.total),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              // Remove button
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                color: _items.length > 1 ? Colors.red.shade600 : Colors.grey,
                                onPressed: _items.length > 1 ? () => _removeItem(index) : null,
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                      const Divider(),

                      // Total Summary Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Valor Total do Pedido:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(_calculatedGrandTotal),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        LoadingButton(
          isLoading: _isLoading,
          onPressed: _isLoadingCustomers ? null : _handleSave,
          label: isEditing ? 'Salvar Venda' : 'Concluir Venda',
        ),
      ],
    );
  }
}