import 'package:flutter/material.dart';

/// Campo de busca padronizado com ícone de pesquisa, botão de limpar reativo e ação de submissão.
class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;

        return TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      controller.clear();
                      if (onClear != null) {
                        onClear!();
                      } else if (onSubmitted != null) {
                        onSubmitted!('');
                      }
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
          ),
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}

