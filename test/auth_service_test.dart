import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/dtos/auth/login_request_dto.dart';
import 'package:birdle/services/mock_auth_service.dart';

void main() {
  group('MockAuthService Tests', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService(delay: Duration.zero);
    });

    test('deve autenticar usuário administrador com sucesso', () async {
      const dto = LoginRequestDto(
        email: 'admin@empresa.com.br',
        password: 'admin123',
      );

      final response = await authService.login(dto);
      expect(response.token, isNotEmpty);
      expect(response.user.email, equals('admin@empresa.com.br'));
      expect(response.user.role, equals('Administrador'));

      final currentUser = await authService.getCurrentUser();
      expect(currentUser?.email, equals('admin@empresa.com.br'));
    });

    test('deve autenticar usuário comercial com sucesso', () async {
      const dto = LoginRequestDto(
        email: 'vendas@empresa.com.br',
        password: 'vendas123',
      );

      final response = await authService.login(dto);
      expect(response.token, isNotEmpty);
      expect(response.user.email, equals('vendas@empresa.com.br'));
      expect(response.user.role, equals('Vendedor'));
    });

    test('deve falhar ao informar senha incorreta', () async {
      const dto = LoginRequestDto(
        email: 'admin@empresa.com.br',
        password: 'senha_errada',
      );

      expect(
        () async => await authService.login(dto),
        throwsA(isA<Exception>()),
      );
    });

    test('deve realizar logout com sucesso e limpar sessão', () async {
      const dto = LoginRequestDto(
        email: 'admin@empresa.com.br',
        password: 'admin123',
      );

      await authService.login(dto);
      expect(await authService.getCurrentUser(), isNotNull);

      await authService.logout();
      expect(await authService.getCurrentUser(), isNull);
    });
  });
}
