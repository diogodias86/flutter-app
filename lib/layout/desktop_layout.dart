import 'package:flutter/material.dart';
import '../dtos/auth/user_response_dto.dart';
import '../pages/customers/customers_page.dart';
import '../pages/sales/sales_page.dart';
import '../services/customer_service.dart';
import '../services/mock_customer_service.dart';
import '../services/mock_sale_service.dart';
import '../services/sale_service.dart';
import '../widgets/confirm_dialog.dart';
import 'app_header.dart';
import 'app_sidebar.dart';

class DesktopLayout extends StatefulWidget {
  final CustomerService? customerService;
  final SaleService? saleService;
  final UserResponseDto? currentUser;
  final VoidCallback? onLogout;

  const DesktopLayout({
    super.key,
    this.customerService,
    this.saleService,
    this.currentUser,
    this.onLogout,
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  BackofficeSection _currentSection = BackofficeSection.customers;
  late final CustomerService _customerService;
  late final SaleService _saleService;

  @override
  void initState() {
    super.initState();
    _customerService = widget.customerService ?? MockCustomerService();
    _saleService = widget.saleService ??
        MockSaleService(customerService: _customerService);
  }

  Future<void> _handleLogoutConfirmation() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Encerrar Sessão',
      message: 'Deseja realmente sair do sistema de backoffice?',
      confirmLabel: 'Sair',
      isDestructive: false,
    );

    if (confirmed && widget.onLogout != null) {
      widget.onLogout!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _currentSection == BackofficeSection.customers
        ? 'Gestão de Clientes'
        : 'Gestão de Pedidos e Vendas';

    final subtitle = _currentSection == BackofficeSection.customers
        ? 'Consulte, cadastre e gerencie a carteira de clientes'
        : 'Acompanhe os pedidos de venda, itens faturados e valores';

    return Scaffold(
      body: Row(
        children: [
          // Fixed Left Sidebar Menu
          AppSidebar(
            currentSection: _currentSection,
            onSectionSelected: (section) {
              setState(() => _currentSection = section);
            },
          ),

          // Main Area (Header + Page Content)
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: title,
                  subtitle: subtitle,
                  user: widget.currentUser,
                  onLogout: widget.onLogout != null ? _handleLogoutConfirmation : null,
                ),
                Expanded(
                  child: _currentSection == BackofficeSection.customers
                      ? CustomersPage(
                          key: const ValueKey('customers_page'),
                          customerService: _customerService,
                        )
                      : SalesPage(
                          key: const ValueKey('sales_page'),
                          saleService: _saleService,
                          customerService: _customerService,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
