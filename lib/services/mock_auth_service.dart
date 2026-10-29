import 'dart:async';
import '../dtos/auth/login_request_dto.dart';
import '../dtos/auth/login_response_dto.dart';
import '../dtos/auth/user_response_dto.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  final Duration delay;
  UserResponseDto? _currentUser;
  String? _token;

  MockAuthService({
    this.delay = const Duration(milliseconds: 200),
    UserResponseDto? initialUser,
  }) : _currentUser = initialUser;

  @override
  Future<LoginResponseDto> login(LoginRequestDto dto) async {
    await Future.delayed(delay);

    final email = dto.email.trim().toLowerCase();
    final password = dto.password.trim();

    if (email.isEmpty || password.isEmpty) {
      throw Exception('E-mail e senha são obrigatórios.');
    }

    // Credenciais mock válidas
    if (email == 'admin@empresa.com.br' && password == 'admin123') {
      _currentUser = const UserResponseDto(
        id: 'USR-001',
        name: 'Administrador do Sistema',
        email: 'admin@empresa.com.br',
        role: 'Administrador',
      );
      _token = 'mock-jwt-token-admin-123456';
    } else if (email == 'vendas@empresa.com.br' && password == 'vendas123') {
      _currentUser = const UserResponseDto(
        id: 'USR-002',
        name: 'Operador Comercial',
        email: 'vendas@empresa.com.br',
        role: 'Vendedor',
      );
      _token = 'mock-jwt-token-vendas-123456';
    } else {
      // Também aceita qualquer login se senha for '123456' para facilidade de testes rápidos
      if (password == '123456' && email.contains('@')) {
        final username = email.split('@').first;
        _currentUser = UserResponseDto(
          id: 'USR-999',
          name: username[0].toUpperCase() + username.substring(1),
          email: email,
          role: 'Operador',
        );
        _token = 'mock-jwt-token-custom-${DateTime.now().millisecondsSinceEpoch}';
      } else {
        throw Exception('Credenciais inválidas. Verifique seu e-mail e senha.');
      }
    }

    return LoginResponseDto(
      token: _token!,
      user: _currentUser!,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(delay);
    _currentUser = null;
    _token = null;
  }

  @override
  Future<UserResponseDto?> getCurrentUser() async {
    await Future.delayed(delay);
    return _currentUser;
  }
}
