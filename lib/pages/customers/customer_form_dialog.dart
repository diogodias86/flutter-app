import 'package:flutter/material.dart';

import '../../dtos/customers/create_customer_dto.dart';
import '../../dtos/customers/customer_response_dto.dart';
import '../../dtos/customers/update_customer_dto.dart';
import '../../services/customer_service.dart';
import '../../utils/app_feedback.dart';
import '../../utils/app_validators.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/modal_dialog_header.dart';

class CustomerFormDialog extends StatefulWidget {
  final CustomerService customerService;
  final CustomerResponseDto? customerToEdit;

  const CustomerFormDialog({
    super.key,
    required this.customerService,
    this.customerToEdit,
  });

  static Future<bool?> show(
    BuildContext context, {
    required CustomerService customerService,
    CustomerResponseDto? customerToEdit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomerFormDialog(
        customerService: customerService,
        customerToEdit: customerToEdit,
      ),
    );
  }

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _documentController;
  late String _status;
  bool _isLoading = false;

  bool get isEditing => widget.customerToEdit != null;

  @override
  void initState() {
    super.initState();
    final customer = widget.customerToEdit;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _documentController = TextEditingController(text: customer?.document ?? '');
    _status = customer?.status ?? 'Ativo';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        final dto = UpdateCustomerDto(
          id: widget.customerToEdit!.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          document: _documentController.text.trim(),
          status: _status,
        );
        await widget.customerService.update(dto);
      } else {
        final dto = CreateCustomerDto(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          document: _documentController.text.trim(),
        );
        await widget.customerService.create(dto);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.showError(context, 'Erro ao salvar cliente: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ModalDialogHeader(
        icon: isEditing ? Icons.edit_note_rounded : Icons.person_add_rounded,
        title: isEditing ? 'Editar Cliente' : 'Novo Cliente',
        onClose: _isLoading ? null : () => Navigator.of(context).pop(false),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Código: ${widget.customerToEdit!.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Razão Social / Nome Completo *',
                    hintText: 'Ex: Acme Corporation ou João da Silva',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: AppValidators.combine([
                    AppValidators.required('Informe o nome do cliente'),
                    AppValidators.minLength(3, 'O nome deve ter pelo menos 3 caracteres'),
                  ]),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail Comercial *',
                    hintText: 'Ex: contato@empresa.com.br',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email(
                    requiredMessage: 'Informe o e-mail do cliente',
                    invalidMessage: 'Informe um e-mail válido',
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone / Celular *',
                          hintText: 'Ex: (11) 98765-4321',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: AppValidators.required('Informe o telefone'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _documentController,
                        decoration: const InputDecoration(
                          labelText: 'CPF ou CNPJ *',
                          hintText: 'Ex: 12.345.678/0001-90',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        validator: AppValidators.required('Informe o documento'),
                      ),
                    ),
                  ],
                ),

                if (isEditing) ...[
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status do Cliente',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.toggle_on_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Ativo', child: Text('Ativo')),
                      DropdownMenuItem(value: 'Inativo', child: Text('Inativo')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _status = val);
                      }
                    },
                  ),
                ],
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
          onPressed: _handleSave,
          label: isEditing ? 'Salvar Alterações' : 'Cadastrar',
        ),
      ],
    );
  }
}
