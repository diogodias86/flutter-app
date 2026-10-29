import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:birdle/widgets/app_card.dart';
import 'package:birdle/widgets/empty_state.dart';
import 'package:birdle/widgets/loading_button.dart';
import 'package:birdle/widgets/modal_dialog_header.dart';
import 'package:birdle/widgets/page_container.dart';
import 'package:birdle/widgets/page_footer_summary.dart';
import 'package:birdle/widgets/responsive_data_table.dart';
import 'package:birdle/widgets/search_input_field.dart';
import 'package:birdle/widgets/table_action_buttons.dart';

void main() {
  group('Custom Widgets Tests', () {
    testWidgets('AppCard e PageContainer devem renderizar seus filhos corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageContainer(
              children: [
                AppCard(
                  child: Text('Card Content'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(PageContainer), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });
    testWidgets('EmptyState deve renderizar mensagem e ícone', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              message: 'Nenhum registro encontrado',
            ),
          ),
        ),
      );

      expect(find.text('Nenhum registro encontrado'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('PageFooterSummary deve renderizar texto de resumo e status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageFooterSummary(
              summaryText: 'Total: 10 registros',
            ),
          ),
        ),
      );

      expect(find.text('Total: 10 registros'), findsOneWidget);
      expect(find.text('Atualizado em tempo real'), findsOneWidget);
    });

    testWidgets('TableActionButtons deve disparar callbacks de edição e exclusão', (tester) async {
      bool edited = false;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableActionButtons(
              onEdit: () => edited = true,
              onDelete: () => deleted = true,
              editTooltip: 'Editar Linha',
              deleteTooltip: 'Excluir Linha',
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit_outlined));
      expect(edited, isTrue);

      await tester.tap(find.byIcon(Icons.delete_outline));
      expect(deleted, isTrue);
    });

    testWidgets('ModalDialogHeader deve disparar onClose ao clicar no botão fechar', (tester) async {
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModalDialogHeader(
              icon: Icons.person,
              title: 'Novo Cliente',
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      expect(find.text('Novo Cliente'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, isTrue);
    });

    testWidgets('SearchInputField deve gerenciar digitação e limpeza', (tester) async {
      final controller = TextEditingController(text: 'Pesquisa');
      bool cleared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchInputField(
              controller: controller,
              hintText: 'Buscar...',
              onClear: () => cleared = true,
            ),
          ),
        ),
      );

      expect(find.text('Pesquisa'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      expect(cleared, isTrue);
      expect(controller.text, isEmpty);
    });

    testWidgets('LoadingButton deve exibir spinner quando isLoading=true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              onPressed: null,
              label: 'Salvar',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ResponsiveDataTable deve exibir loading e alternar para linhas', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveDataTable(
              isLoading: true,
              isEmpty: false,
              emptyIcon: Icons.warning,
              emptyMessage: 'Vazio',
              columns: [DataColumn(label: Text('Coluna 1'))],
              rows: [],
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Renderiza com conteúdo
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveDataTable(
              isLoading: false,
              isEmpty: false,
              emptyIcon: Icons.warning,
              emptyMessage: 'Vazio',
              columns: [DataColumn(label: Text('Coluna 1'))],
              rows: [
                DataRow(cells: [DataCell(Text('Dado 1'))]),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Coluna 1'), findsOneWidget);
      expect(find.text('Dado 1'), findsOneWidget);
    });
  });
}