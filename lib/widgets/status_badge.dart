import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (status.toLowerCase()) {
      case 'ativo':
      case 'faturada':
      case 'pago':
      case 'concluída':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        border = const Color(0xFFA5D6A7);
        break;
      case 'pendente':
      case 'em processamento':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        border = const Color(0xFFFFE082);
        break;
      case 'inativo':
      case 'cancelada':
      case 'estornado':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        border = const Color(0xFFEF9A9A);
        break;
      default:
        bg = const Color(0xFFECEFF1);
        fg = const Color(0xFF455A64);
        border = const Color(0xFFCFD8DC);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
