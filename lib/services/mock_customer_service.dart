import 'dart:async';
import '../dtos/customers/create_customer_dto.dart';
import '../dtos/customers/customer_response_dto.dart';
import '../dtos/customers/update_customer_dto.dart';
import 'customer_service.dart';

class MockCustomerService implements CustomerService {
  final List<CustomerResponseDto> _customers = [
    CustomerResponseDto(
      id: 'CLI-001',
      name: 'TechSolutions Informática Ltda',
      email: 'contato@techsolutions.com.br',
      phone: '(11) 98765-4321',
      document: '12.345.678/0001-90',
      status: 'Ativo',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    CustomerResponseDto(
      id: 'CLI-002',
      name: 'Maria Clara Vasconcelos',
      email: 'maria.vasconcelos@email.com',
      phone: '(21) 99123-4567',
      document: '123.456.789-00',
      status: 'Ativo',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    CustomerResponseDto(
      id: 'CLI-003',
      name: 'Distribuidora Alvorada S/A',
      email: 'vendas@alvorada.com.br',
      phone: '(31) 3245-8800',
      document: '98.765.432/0001-10',
      status: 'Ativo',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    CustomerResponseDto(
      id: 'CLI-004',
      name: 'Roberto Carlos Silva',
      email: 'roberto.silva@empresa.com.br',
      phone: '(41) 98877-6655',
      document: '234.567.890-12',
      status: 'Inativo',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    CustomerResponseDto(
      id: 'CLI-005',
      name: 'Nexus Logística e Transportes',
      email: 'operacional@nexuslog.com.br',
      phone: '(19) 3456-7890',
      document: '45.678.901/0001-23',
      status: 'Ativo',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  int _nextId = 6;
  final Duration delay;

  MockCustomerService({this.delay = const Duration(milliseconds: 150)});

  @override
  Future<List<CustomerResponseDto>> getAll({String? query}) async {
    await Future.delayed(delay);
    if (query == null || query.trim().isEmpty) {
      return List.unmodifiable(_customers);
    }
    final cleanQuery = query.toLowerCase().trim();
    return List.unmodifiable(_customers.where((c) {
      return c.name.toLowerCase().contains(cleanQuery) ||
          c.email.toLowerCase().contains(cleanQuery) ||
          c.document.toLowerCase().contains(cleanQuery) ||
          c.id.toLowerCase().contains(cleanQuery);
    }));
  }

  @override
  Future<CustomerResponseDto?> getById(String id) async {
    await Future.delayed(delay);
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CustomerResponseDto> create(CreateCustomerDto dto) async {
    await Future.delayed(delay);
    final id = 'CLI-${_nextId.toString().padLeft(3, '0')}';
    _nextId++;

    final newCustomer = CustomerResponseDto(
      id: id,
      name: dto.name.trim(),
      email: dto.email.trim(),
      phone: dto.phone.trim(),
      document: dto.document.trim(),
      status: 'Ativo',
      createdAt: DateTime.now(),
    );

    _customers.insert(0, newCustomer);
    return newCustomer;
  }

  @override
  Future<CustomerResponseDto> update(UpdateCustomerDto dto) async {
    await Future.delayed(delay);
    final index = _customers.indexWhere((c) => c.id == dto.id);
    if (index == -1) {
      throw Exception('Cliente ${dto.id} não encontrado.');
    }

    final existing = _customers[index];
    final updated = existing.copyWith(
      name: dto.name.trim(),
      email: dto.email.trim(),
      phone: dto.phone.trim(),
      document: dto.document.trim(),
      status: dto.status,
    );

    _customers[index] = updated;
    return updated;
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(delay);
    final countBefore = _customers.length;
    _customers.removeWhere((c) => c.id == id);
    return _customers.length < countBefore;
  }
}
