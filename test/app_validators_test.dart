import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/utils/app_validators.dart';

void main() {
  group('AppValidators Tests', () {
    test('required deve acusar campos nulos ou em branco', () {
      final validator = AppValidators.required('Obrigatório');
      expect(validator(null), equals('Obrigatório'));
      expect(validator(''), equals('Obrigatório'));
      expect(validator('   '), equals('Obrigatório'));
      expect(validator('texto'), isNull);
    });

    test('email deve validar formato adequadamente', () {
      final strictValidator = AppValidators.email(strict: true);
      expect(strictValidator(null), isNotNull);
      expect(strictValidator('invalido'), equals('Informe um e-mail válido'));
      expect(strictValidator('invalido@com'), equals('Informe um e-mail válido'));
      expect(strictValidator('valido@empresa.com.br'), isNull);

      final nonStrictValidator = AppValidators.email(strict: false);
      expect(nonStrictValidator('admin@empresa'), isNull);
    });

    test('minLength deve validar tamanho mínimo', () {
      final validator = AppValidators.minLength(3, 'Mínimo 3');
      expect(validator('ab'), equals('Mínimo 3'));
      expect(validator('abc'), isNull);
      expect(validator('abcd'), isNull);
    });

    test('positiveInteger deve validar números inteiros > 0', () {
      final validator = AppValidators.positiveInteger();
      expect(validator('0'), equals('Inválido'));
      expect(validator('-1'), equals('Inválido'));
      expect(validator('abc'), equals('Inválido'));
      expect(validator('5'), isNull);
    });

    test('positiveCurrency deve validar valores monetários', () {
      final validator = AppValidators.positiveCurrency();
      expect(validator(''), equals('Inválido'));
      expect(validator('0,00'), isNull); // 0,00 não é empty
      expect(validator('150,50'), isNull);
    });

    test('combine deve validar em cadeia', () {
      final combined = AppValidators.combine([
        AppValidators.required('Informe o nome'),
        AppValidators.minLength(3, 'Pelo menos 3 letras'),
      ]);

      expect(combined(''), equals('Informe o nome'));
      expect(combined('ab'), equals('Pelo menos 3 letras'));
      expect(combined('abc'), isNull);
    });
  });
}

