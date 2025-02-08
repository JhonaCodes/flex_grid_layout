
import 'package:flex_grid_layout/flex_grid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlexGridLayout Widget Tests', () {
    testWidgets('renders with empty children list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlexGridLayout(
            children: [],
          ),
        ),
      );

      expect(find.byType(FlexGridLayout), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders correct number of items', (WidgetTester tester) async {
      final testItems = List.generate(
        5,
        (index) => Container(key: Key('item_$index')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FlexGridLayout(
            children: testItems,
          ),
        ),
      );

      for (var i = 0; i < testItems.length; i++) {
        expect(find.byKey(Key('item_$i')), findsOneWidget);
      }
    });

    testWidgets('respects minItemWidth constraint',
        (WidgetTester tester) async {
      const minItemWidth = 200.0;
      final testItems = List.generate(
        4,
        (index) => Container(key: Key('item_$index')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 600, // Should fit 2 items per row with 200 minWidth
            child: FlexGridLayout(
              minItemWidth: minItemWidth,
              children: testItems,
            ),
          ),
        ),
      );

      // Verify that items are arranged in 2 rows
      final firstRowItems = find.ancestor(
        of: find.byKey(Key('item_0')),
        matching: find.byType(Row),
      );
      expect(firstRowItems, findsOneWidget);
    });

    testWidgets('applies correct spacing between items',
        (WidgetTester tester) async {
      const spacing = 16.0;
      final testItems = List.generate(
        2,
        (index) => Container(
          key: ValueKey('item_$index'),
          width: 200, // Fixed width para asegurar el tamaño
          height: 100, // Fixed height para asegurar el tamaño
          color: Colors.blue, // Color para visualización
          child: Center(child: Text('Item $index')),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 500,
                color: Colors.white,
                child: FlexGridLayout(
                  spacing: spacing,
                  minItemWidth: 200,
                  children: testItems, // Coincide con el ancho del Container
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Encontrar los elementos por sus ValueKeys
      final firstItemFinder = find.byKey(const ValueKey('item_0'));
      final secondItemFinder = find.byKey(const ValueKey('item_1'));

      // Obtener los Rects de los elementos
      final firstItemRect = tester.getRect(firstItemFinder);
      final secondItemRect = tester.getRect(secondItemFinder);

      // Verificar que los elementos están en la misma fila
      expect(firstItemRect.top, equals(secondItemRect.top),
          reason: 'Los elementos deberían estar en la misma fila');

      // Verificar el espaciado horizontal entre elementos
      final actualSpacing = secondItemRect.left - firstItemRect.right;
      expect(actualSpacing, equals(spacing),
          reason:
              'El espaciado entre elementos debería ser $spacing, pero es $actualSpacing');
    });

    testWidgets('handles window resize', (WidgetTester tester) async {
      final testItems = List.generate(
        6,
        (index) => Container(key: Key('item_$index')),
      );

      // Start with a wide screen
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlexGridLayout(
              minItemWidth: 300,
              children: testItems,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Get items in first row
      final firstRowFinder = find.descendant(
        of: find.byType(Row).first,
        matching: find.byType(Container),
      );
      final initialItemsInFirstRow = tester.widgetList(firstRowFinder).length;

      // Resize to a narrow screen
      await tester.binding.setSurfaceSize(const Size(500, 800));
      await tester.pumpAndSettle();

      // Get items in first row after resize
      final firstRowFinderAfterResize = find.descendant(
        of: find.byType(Row).first,
        matching: find.byType(Container),
      );
      final finalItemsInFirstRow =
          tester.widgetList(firstRowFinderAfterResize).length;

      // After resizing to a narrower width, we should have fewer items in the first row
      expect(finalItemsInFirstRow, lessThan(initialItemsInFirstRow));
    });

    testWidgets('applies custom runSpacing between rows',
        (WidgetTester tester) async {
      const runSpacing = 24.0;
      final testItems = List.generate(
        4,
        (index) => Container(
          key: Key('item_$index'),
          height: 100,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 400, // Force 2 rows with 2 items each
            child: FlexGridLayout(
              minItemWidth: 180,
              runSpacing: runSpacing,
              children: testItems,
            ),
          ),
        ),
      );

      // Verify vertical spacing between rows
      final firstRowItem = tester.getRect(find.byKey(Key('item_0')));
      final secondRowItem = tester.getRect(find.byKey(Key('item_2')));
      expect(secondRowItem.top - firstRowItem.bottom, runSpacing);
    });

    testWidgets('respects maxItemsPerRow constraint',
        (WidgetTester tester) async {
      const maxItems = 2;
      final testItems = List.generate(
        6,
        (index) => Container(
          key: ValueKey('item_$index'),
          color: Colors.blue,
          child: Center(child: Text('$index')),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 1000,
              color: Colors.white,
              child: FlexGridLayout(
                maxItemsPerRow: maxItems,
                minItemWidth: 200,
                spacing: 8,
                runSpacing: 8,
                children: testItems,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the first Row widget
      final firstRowFinder = find.byType(Row).first;
      final firstRow = tester.widget<Row>(firstRowFinder);

      // Count the items in the first row
      final itemsInFirstRow = firstRow.children.length;

      // Verify that the number of items in the first row equals maxItems
      expect(itemsInFirstRow, equals(maxItems),
          reason:
              'First row should contain exactly $maxItems items due to maxItemsPerRow constraint');
    });

    testWidgets('applies minItemHeight when specified',
        (WidgetTester tester) async {
      const minHeight = 150.0;
      final testItems = List.generate(
        2,
        (index) => Container(key: Key('item_$index')),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FlexGridLayout(
            minItemHeight: minHeight,
            children: testItems,
          ),
        ),
      );

      final itemRect = tester.getRect(find.byKey(Key('item_0')));
      expect(itemRect.height, minHeight);
    });
  });
}
