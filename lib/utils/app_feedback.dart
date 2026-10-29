import 'package:flutter/material.dart';

/// Centralizador de mensagens de feedback (SnackBars) da aplicação.
class AppFeedback {
  AppFeedback._();

  /// Exibe um feedback de sucesso (verde).
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.green,
    );
  }

  /// Exibe um feedback de erro (vermelho).
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  /// Exibe um feedback informativo ou de atualização (azul).
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.blue,
    );
  }

  /// Exibe um aviso neutro ou de exclusão (preto/cinza escuro).
  static void showNotice(BuildContext context, String message) {
    _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.black87,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

