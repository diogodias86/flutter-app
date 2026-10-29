import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/dtos/customers/create_customer_dto.dart';
import 'package:birdle/dtos/customers/update_customer_dto.dart';
import 'package:birdle/services/mock_customer_service.dart';

void main() {
  group('MockCustomerService Tests', () {
    late MockCustomerService service;

    setUp(() {
      service = MockCustomerService(delay: Duration.zero);
    });

    test('deve listar todos os clientes iniciais', () async {
      final customers = await service.getAll();
      expect(customers.isNotEmpty, isTrue);
      expect(customers.length, greaterThanOrEqualTo(5));
    });

    test('deve filtrar clientes por termo de busca', () async {
      final result = await service.getAll(query: 'TechSolutions');
      expect(result.length, equals(1));
      expect(result.first.name, contains('TechSolutions'));
    });

    test('deve criar um novo cliente com sucesso usando CreateCustomerDto', () async {
      const dto = CreateCustomerDto(
        name: 'Empresa Teste Brasil',
        email: 'contato@empresateste.com.br',
        phone: '(11) 99999-8888',
        document: '55.666.777/0001-88',
      );

      final created = await service.create(dto);
      expect(created.id, startsWith('CLI-'));
      expect(created.name, equals('Empresa Teste Brasil'));
      expect(created.status, equals('Ativo'));

      final all = await service.getAll();
      expect(all.any((c) => c.id == created.id), isTrue);
    });

    test('deve atualizar cliente existente usando UpdateCustomerDto', () async {
      final initialList = await service.getAll();
      final target = initialList.first;

      final updateDto = UpdateCustomerDto(
        id: target.id,
        name: 'Nome Atualizado S/A',
        email: 'novoemail@atualizado.com',
        phone: target.phone,
        document: target.document,
        status: 'Inativo',
      );

      final updated = await service.update(updateDto);
      expect(updated.id, equals(target.id));
      expect(updated.name, equals('Nome Atualizado S/A'));
      expect(updated.status, equals('Inativo'));

      final retrieved = await service.getById(target.id);
      expect(retrieved?.name, equals('Nome Atualizado S/A'));
      expect(retrieved?.status, equals('Inativo'));
    });

    test('deve excluir cliente com sucesso', () async {
      final initialList = await service.getAll();
      final target = initialList.first;

      final success = await service.delete(target.id);
      expect(success, isTrue);

      final retrieved = await service.getById(target.id);
      expect(retrieved, isNull);
    });
  });
}
