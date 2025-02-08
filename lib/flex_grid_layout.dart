import 'package:flutter/material.dart';

class FlexGridLayout extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int maxItemsPerRow;
  final double minItemWidth;
  final double? minItemHeight;

  const FlexGridLayout(
      {super.key,
      required this.children,
      this.spacing = 8,
      this.runSpacing = 8,
      this.maxItemsPerRow = 3,
      this.minItemWidth = 470,
      this.minItemHeight});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int itemCount = children.length;

        int itemsPerRow = (availableWidth / (minItemWidth + spacing))
            .floor()
            .clamp(1, maxItemsPerRow);

        int rows = (itemCount / itemsPerRow).ceil();
        double itemWidth =
            (availableWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow;

        return SingleChildScrollView(
          child: Column(
            children: List.generate(rows, (rowIndex) {
              int startIndex = rowIndex * itemsPerRow;
              int endIndex = (startIndex + itemsPerRow).clamp(0, itemCount);

              return Padding(
                padding: EdgeInsets.only(
                    bottom: rowIndex < rows - 1 ? runSpacing : 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: children
                      .sublist(startIndex, endIndex)
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(
                            right: entry.key < endIndex - startIndex - 1
                                ? spacing
                                : 0,
                          ),
                          child: SizedBox(
                            width: itemWidth,
                            height: minItemHeight,
                            child: entry.value,
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
