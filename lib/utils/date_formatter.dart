/// Utilitário para formatação padronizada de datas no formato brasileiro.
class DateFormatter {
  DateFormatter._();

  /// Formata uma data no formato brasileiro "DD/MM/AAAA".
  /// Exemplo: DateTime(2026, 5, 4) -> "04/05/2026"
  static String format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  /// Formata uma data com horário "DD/MM/AAAA às HH:mm".
  static String formatWithTime(DateTime date) {
    final dateStr = format(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$dateStr às $hour:$minute';
  }
}

