# FlexGridLayout

A responsive grid layout widget for Flutter that automatically arranges items based on available width.

[![pub package](https://img.shields.io/pub/v/flex_grid_layout.svg)](https://pub.dev/packages/flex_grid_layout)
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)

## Features

- 🔄 Responsive grid that adapts to screen size
- 📱 Automatic column adjustment based on available width
- 📐 Customizable minimum item width and height
- 🎯 Control over maximum items per row
- 🌟 Flexible spacing between items and rows
- 📜 Built-in scrolling support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flex_grid_layout: ^1.0.0
```

## Usage

Simple example:

```dart
FlexGridLayout(
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    Card(child: Text('Item 3')),
  ],
)
```

Customized example:

```dart
FlexGridLayout(
  children: items,
  minItemWidth: 300,
  maxItemsPerRow: 3,
  spacing: 16,
  runSpacing: 16,
  minItemHeight: 200,
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| children | List<Widget> | required | The widgets to display in the grid |
| spacing | double | 8.0 | Horizontal space between items |
| runSpacing | double | 8.0 | Vertical space between rows |
| maxItemsPerRow | int | 3 | Maximum number of items in a row |
| minItemWidth | double | 470.0 | Minimum width for each item |
| minItemHeight | double? | null | Optional minimum height for each item |

## 🎯 Examples

### Basic Grid

```dart
FlexGridLayout(
  children: List.generate(
    9,
    (index) => Card(
      child: Center(
        child: Text('Item $index'),
      ),
    ),
  ),
)
```

### Dashboard Layout

```dart
FlexGridLayout(
  minItemWidth: 350,
  maxItemsPerRow: 3,
  spacing: 16,
  runSpacing: 16,
  children: [
    DashboardCard(
      title: 'Sales',
      value: '\$15,350',
    ),
    DashboardCard(
      title: 'Users',
      value: '2,350',
    ),
    DashboardCard(
      title: 'Revenue',
      value: '\$50,350',
    ),
  ],
)
```

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

## 📝 License

MIT License - see the [LICENSE](LICENSE) file for details

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!.



## ⭐️ Show your support

Give a ⭐️ if this project helped you!

---

Made with ❤️ by [Jhonacode](https://github.com/JhonaCodes)