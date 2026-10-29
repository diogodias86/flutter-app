import 'currency_formatter.dart';

/// Funções utilitárias reutilizáveis para validação de campos de formulário.
class AppValidators {
  AppValidators._();

  /// Validador que verifica se o campo foi preenchido.
  static String? Function(String?) required([String? message]) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'Campo obrigatório';
      }
      return null;
    };
  }

  /// Validador de e-mail corporativo/pessoal.
  /// Se [strict] for verdadeiro, exige também um ponto após o arroba.
  static String? Function(String?) email({
    String? requiredMessage,
    String? invalidMessage,
    bool strict = true,
  }) {
    return (value) {
      final req = required(requiredMessage)(value);
      if (req != null) return req;

      final trimmed = value!.trim();
      final hasAt = trimmed.contains('@');
      final hasDot = trimmed.contains('.');

      if (!hasAt || (strict && !hasDot)) {
        return invalidMessage ?? 'Informe um e-mail válido';
      }
      return null;
    };
  }

  /// Validador de comprimento mínimo de caracteres.
  static String? Function(String?) minLength(int length, [String? message]) {
    return (value) {
      if (value != null && value.trim().isNotEmpty && value.trim().length < length) {
        return message ?? 'O valor deve conter pelo menos $length caracteres';
      }
      return null;
    };
  }

  /// Validador para quantidade inteira positiva (> 0).
  static String? Function(String?) positiveInteger([String? message]) {
    return (value) {
      final n = int.tryParse(value ?? '');
      if (n == null || n <= 0) {
        return message ?? 'Inválido';
      }
      return null;
    };
  }

  /// Validador para valor monetário positivo (> 0).
  static String? Function(String?) positiveCurrency([String? message]) {
    return (value) {
      final p = CurrencyFormatter.parse(value);
      if (p <= 0 && (value == null || value.trim().isEmpty)) {
        return message ?? 'Inválido';
      }
      return null;
    };
  }

  /// Combina múltiplos validadores em um único validator, retornando o primeiro erro encontrado.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}

