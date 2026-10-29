import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/dtos/sales/create_sale_dto.dart';
import 'package:birdle/dtos/sales/update_sale_dto.dart';
import 'package:birdle/services/mock_customer_service.dart';
import 'package:birdle/services/mock_sale_service.dart';

void main() {
  group('MockSaleService Tests', () {
    late MockCustomerService customerService;
    late MockSaleService saleService;

    setUp(() {
      customerService = MockCustomerService(delay: Duration.zero);
      saleService = MockSaleService(
        customerService: customerService,
        delay: Duration.zero,
      );
    });

    test('deve listar todas as vendas iniciais', () async {
      final sales = await saleService.getAll();
      expect(sales.isNotEmpty, isTrue);
      expect(sales.length, greaterThanOrEqualTo(4));
    });

    test('deve filtrar vendas por status', () async {
      final pending = await saleService.getAll(statusFilter: 'Pendente');
      expect(pending.every((s) => s.status.toLowerCase() == 'pendente'), isTrue);

      final invoiced = await saleService.getAll(statusFilter: 'Faturada');
      expect(invoiced.every((s) => s.status.toLowerCase() == 'faturada'), isTrue);
    });

    test('deve criar uma nova venda com múltiplos itens e calcular total correto', () async {
      const dto = CreateSaleDto(
        customerId: 'CLI-001',
        status: 'Pendente',
        items: [
          CreateSaleItemDto(
            description: 'Item de Teste 1',
            quantity: 2,
            unitPrice: 150.0,
          ),
          CreateSaleItemDto(
            description: 'Item de Teste 2',
            quantity: 1,
            unitPrice: 200.0,
          ),
        ],
      );

      final created = await saleService.create(dto);
      expect(created.id, startsWith('VEN-'));
      expect(created.items.length, equals(2));
      // Total: (2 * 150) + (1 * 200) = 500
      expect(created.totalAmount, equals(500.0));
      expect(created.customerName, equals('TechSolutions Informática Ltda'));
    });

    test('deve atualizar venda existente usando UpdateSaleDto', () async {
      final list = await saleService.getAll();
      final target = list.first;

      final updateDto = UpdateSaleDto(
        id: target.id,
        customerId: target.customerId,
        status: 'Cancelada',
        items: const [
          UpdateSaleItemDto(
            description: 'Item Modificado',
            quantity: 3,
            unitPrice: 100.0,
          ),
        ],
      );

      final updated = await saleService.update(updateDto);
      expect(updated.id, equals(target.id));
      expect(updated.status, equals('Cancelada'));
      expect(updated.totalAmount, equals(300.0));
    });

    test('deve excluir venda com sucesso', () async {
      final list = await saleService.getAll();
      final target = list.first;

      final success = await saleService.delete(target.id);
      expect(success, isTrue);

      final retrieved = await saleService.getById(target.id);
      expect(retrieved, isNull);
    });
  });
}
