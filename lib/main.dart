import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dtos/auth/user_response_dto.dart';
import 'layout/desktop_layout.dart';
import 'pages/auth/login_page.dart';
import 'services/auth_service.dart';
import 'services/customer_service.dart';
import 'services/mock_auth_service.dart';
import 'services/mock_customer_service.dart';
import 'services/mock_sale_service.dart';
import 'services/sale_service.dart';
import 'layout/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BackofficeApp());
}

class DesktopCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class BackofficeApp extends StatefulWidget {
  final CustomerService? customerService;
  final SaleService? saleService;
  final AuthService? authService;

  const BackofficeApp({
    super.key,
    this.customerService,
    this.saleService,
    this.authService,
  });

  @override
  State<BackofficeApp> createState() => _BackofficeAppState();
}

class _BackofficeAppState extends State<BackofficeApp> {
  late final CustomerService _customerService;
  late final SaleService _saleService;
  late final AuthService _authService;
  UserResponseDto? _currentUser;

  @override
  void initState() {
    super.initState();
    _customerService = widget.customerService ?? MockCustomerService();
    _saleService =
        widget.saleService ??
        MockSaleService(customerService: _customerService);
    _authService = widget.authService ?? MockAuthService();
  }

  void _onLoginSuccess(UserResponseDto user) {
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      setState(() {
        _currentUser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backoffice de Vendas',
      debugShowCheckedModeBanner: false,
      scrollBehavior: DesktopCustomScrollBehavior(),
      theme: AppTheme.build(),
      home: _currentUser == null
          ? LoginPage(
              key: const ValueKey('login_page'),
              authService: _authService,
              onLoginSuccess: _onLoginSuccess,
            )
          : DesktopLayout(
              key: const ValueKey('desktop_layout'),
              customerService: _customerService,
              saleService: _saleService,
              currentUser: _currentUser,
              onLogout: _handleLogout,
            ),
    );
  }
}
