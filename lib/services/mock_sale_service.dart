import 'dart:async';
import '../dtos/sales/create_sale_dto.dart';
import '../dtos/sales/sale_response_dto.dart';
import '../dtos/sales/update_sale_dto.dart';
import 'customer_service.dart';
import 'sale_service.dart';

class MockSaleService implements SaleService {
  final CustomerService customerService;
  final Duration delay;

  final List<SaleResponseDto> _sales = [
    SaleResponseDto(
      id: 'VEN-1001',
      customerId: 'CLI-001',
      customerName: 'TechSolutions Informática Ltda',
      saleDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Faturada',
      totalAmount: 14500.00,
      items: const [
        SaleItemResponseDto(
          id: 'ITEM-1',
          description: 'Licença Backoffice Anual Enterprise',
          quantity: 2,
          unitPrice: 5000.00,
        ),
        SaleItemResponseDto(
          id: 'ITEM-2',
          description: 'Serviço de Implantação e Customização',
          quantity: 1,
          unitPrice: 4500.00,
        ),
      ],
    ),
    SaleResponseDto(
      id: 'VEN-1002',
      customerId: 'CLI-002',
      customerName: 'Maria Clara Vasconcelos',
      saleDate: DateTime.now().subtract(const Duration(days: 4)),
      status: 'Pendente',
      totalAmount: 3200.00,
      items: const [
        SaleItemResponseDto(
          id: 'ITEM-3',
          description: 'Consultoria Financeira Especializada',
          quantity: 1,
          unitPrice: 3200.00,
        ),
      ],
    ),
    SaleResponseDto(
      id: 'VEN-1003',
      customerId: 'CLI-003',
      customerName: 'Distribuidora Alvorada S/A',
      saleDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Faturada',
      totalAmount: 27800.00,
      items: const [
        SaleItemResponseDto(
          id: 'ITEM-4',
          description: 'Módulo de Gestão de Estoque Multi-Filial',
          quantity: 1,
          unitPrice: 18000.00,
        ),
        SaleItemResponseDto(
          id: 'ITEM-5',
          description: 'Treinamento de Equipe Operacional (Horas)',
          quantity: 14,
          unitPrice: 700.00,
        ),
      ],
    ),
    SaleResponseDto(
      id: 'VEN-1004',
      customerId: 'CLI-005',
      customerName: 'Nexus Logística e Transportes',
      saleDate: DateTime.now().subtract(const Duration(hours: 18)),
      status: 'Pendente',
      totalAmount: 8900.00,
      items: const [
        SaleItemResponseDto(
          id: 'ITEM-6',
          description: 'Integração de Rastreamento de Frota',
          quantity: 1,
          unitPrice: 8900.00,
        ),
      ],
    ),
  ];

  int _nextSaleId = 1005;
  int _nextItemId = 7;

  MockSaleService({
    required this.customerService,
    this.delay = const Duration(milliseconds: 150),
  });

  @override
  Future<List<SaleResponseDto>> getAll({
    String? statusFilter,
    String? query,
  }) async {
    await Future.delayed(delay);

    return List.unmodifiable(_sales.where((sale) {
      final matchesStatus = statusFilter == null ||
          statusFilter == 'Todos' ||
          sale.status.toLowerCase() == statusFilter.toLowerCase();

      final cleanQuery = query?.toLowerCase().trim() ?? '';
      final matchesQuery = cleanQuery.isEmpty ||
          sale.id.toLowerCase().contains(cleanQuery) ||
          sale.customerName.toLowerCase().contains(cleanQuery);

      return matchesStatus && matchesQuery;
    }));
  }

  @override
  Future<SaleResponseDto?> getById(String id) async {
    await Future.delayed(delay);
    try {
      return _sales.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<SaleResponseDto> create(CreateSaleDto dto) async {
    await Future.delayed(delay);

    final customer = await customerService.getById(dto.customerId);
    final customerName = customer?.name ?? 'Cliente Desconhecido';

    final saleId = 'VEN-$_nextSaleId';
    _nextSaleId++;

    final responseItems = dto.items.map((item) {
      final itemId = 'ITEM-$_nextItemId';
      _nextItemId++;
      return SaleItemResponseDto(
        id: itemId,
        description: item.description.trim(),
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      );
    }).toList();

    final total = responseItems.fold(0.0, (acc, item) => acc + item.totalPrice);

    final newSale = SaleResponseDto(
      id: saleId,
      customerId: dto.customerId,
      customerName: customerName,
      saleDate: DateTime.now(),
      status: dto.status,
      items: responseItems,
      totalAmount: total,
    );

    _sales.insert(0, newSale);
    return newSale;
  }

  @override
  Future<SaleResponseDto> update(UpdateSaleDto dto) async {
    await Future.delayed(delay);

    final index = _sales.indexWhere((s) => s.id == dto.id);
    if (index == -1) {
      throw Exception('Venda ${dto.id} não encontrada.');
    }

    final customer = await customerService.getById(dto.customerId);
    final customerName = customer?.name ?? _sales[index].customerName;

    final responseItems = dto.items.map((item) {
      final itemId = item.id ?? 'ITEM-$_nextItemId';
      if (item.id == null) _nextItemId++;

      return SaleItemResponseDto(
        id: itemId,
        description: item.description.trim(),
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      );
    }).toList();

    final total = responseItems.fold(0.0, (acc, item) => acc + item.totalPrice);

    final updated = _sales[index].copyWith(
      customerId: dto.customerId,
      customerName: customerName,
      status: dto.status,
      items: responseItems,
      totalAmount: total,
    );

    _sales[index] = updated;
    return updated;
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(delay);
    final countBefore = _sales.length;
    _sales.removeWhere((s) => s.id == id);
    return _sales.length < countBefore;
  }
}
