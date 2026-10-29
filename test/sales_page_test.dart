import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/pages/sales/sales_page.dart';
import 'package:birdle/services/mock_customer_service.dart';
import 'package:birdle/services/mock_sale_service.dart';

void main() {
  group('SalesPage Widget Tests', () {
    late MockCustomerService customerService;
    late MockSaleService saleService;

    setUp(() {
      customerService = MockCustomerService(delay: Duration.zero);
      saleService = MockSaleService(
        customerService: customerService,
        delay: Duration.zero,
      );
    });

    testWidgets('deve renderizar a listagem de vendas com total faturado', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SalesPage(
              saleService: saleService,
              customerService: customerService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('VEN-1001'), findsOneWidget);
      expect(find.text('TechSolutions Informática Ltda'), findsOneWidget);
      expect(find.text('Nova Venda'), findsOneWidget);
      expect(find.text('Filtrar Status'), findsOneWidget);
    });

    testWidgets('deve filtrar vendas por status', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SalesPage(
              saleService: saleService,
              customerService: customerService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Encontra o dropdown de status
      final dropdownFinder = find.byType(DropdownButtonFormField<String>);
      expect(dropdownFinder, findsOneWidget);

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Seleciona "Cancelada" (que inicialmente tem 0 vendas)
      await tester.tap(find.text('Cancelada').last);
      await tester.pumpAndSettle();

      expect(find.text('Nenhuma venda encontrada'), findsOneWidget);
    });
  });
}