import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/pages/customers/customers_page.dart';
import 'package:birdle/services/mock_customer_service.dart';

void main() {
  group('CustomersPage Widget Tests', () {
    late MockCustomerService customerService;

    setUp(() {
      customerService = MockCustomerService(delay: Duration.zero);
    });

    testWidgets('deve carregar e renderizar a lista de clientes', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomersPage(customerService: customerService),
          ),
        ),
      );

      // Aguarda carregamento inicial
      await tester.pumpAndSettle();

      expect(find.text('TechSolutions Informática Ltda'), findsOneWidget);
      expect(find.text('Maria Clara Vasconcelos'), findsOneWidget);
      expect(find.text('Novo Cliente'), findsOneWidget);
      expect(find.text('Atualizar'), findsOneWidget);
    });

    testWidgets('deve filtrar clientes pela barra de pesquisa', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomersPage(customerService: customerService),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'TechSolutions');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('TechSolutions Informática Ltda'), findsOneWidget);
      expect(find.text('Maria Clara Vasconcelos'), findsNothing);
    });
  });
}