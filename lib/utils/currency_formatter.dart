class CurrencyFormatter {
  /// Formata um valor numérico para o padrão de moeda brasileiro (BRL).
  /// Exemplo: 14500.5 -> "R$ 14.500,50"
  static String format(double value) {
    final isNegative = value < 0;
    final absValue = value.abs();
    final parts = absValue.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(integerPart[i]);
    }

    final sign = isNegative ? '-' : '';
    return 'R\$ $sign${buffer.toString()},$decimalPart';
  }

  /// Converte uma String monetária para double, tratando separadores de milhar e decimais.
  /// Exemplos aceitos: "1.250,50", "1250,50", "1250.50", "R$ 1.250,50"
  static double parse(String? text) {
    if (text == null || text.trim().isEmpty) return 0.0;

    String clean = text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .trim();

    // Se possui vírgula como separador decimal (formato BR)
    if (clean.contains(',')) {
      clean = clean.replaceAll('.', '').replaceAll(',', '.');
    }

    return double.tryParse(clean) ?? 0.0;
  }
}
