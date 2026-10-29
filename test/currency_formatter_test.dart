import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('deve formatar valores monetários corretamente para o padrão BRL', () {
      expect(CurrencyFormatter.format(0), equals('R\$ 0,00'));
      expect(CurrencyFormatter.format(5.5), equals('R\$ 5,50'));
      expect(CurrencyFormatter.format(150), equals('R\$ 150,00'));
      expect(CurrencyFormatter.format(1250.75), equals('R\$ 1.250,75'));
      expect(CurrencyFormatter.format(14500.00), equals('R\$ 14.500,00'));
      expect(CurrencyFormatter.format(1234567.89), equals('R\$ 1.234.567,89'));
      expect(CurrencyFormatter.format(-50.25), equals('R\$ -50,25'));
    });

    test('deve converter strings monetárias para double de forma segura', () {
      expect(CurrencyFormatter.parse('14.500,00'), equals(14500.00));
      expect(CurrencyFormatter.parse('14500,50'), equals(14500.50));
      expect(CurrencyFormatter.parse('14500.50'), equals(14500.50));
      expect(CurrencyFormatter.parse('R\$ 1.250,75'), equals(1250.75));
      expect(CurrencyFormatter.parse(''), equals(0.0));
      expect(CurrencyFormatter.parse(null), equals(0.0));
    });
  });
}
