import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/utils/date_formatter.dart';

void main() {
  group('DateFormatter Tests', () {
    test('deve formatar data simples DD/MM/AAAA corretamente', () {
      final date1 = DateTime(2026, 1, 5);
      expect(DateFormatter.format(date1), equals('05/01/2026'));

      final date2 = DateTime(2026, 12, 31);
      expect(DateFormatter.format(date2), equals('31/12/2026'));
    });

    test('deve formatar data com horário corretamente', () {
      final date = DateTime(2026, 5, 10, 8, 5);
      expect(DateFormatter.formatWithTime(date), equals('10/05/2026 às 08:05'));
    });
  });
}

