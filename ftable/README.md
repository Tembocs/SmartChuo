# Flexible Table Widget for Flutter

A highly flexible and customizable data table widget for Flutter applications, designed to meet the specifications outlined in the `custom_table.md` document.

## Features

✅ **Scrolling**
- Vertical and horizontal scrolling support
- Dual scrollbars for easy navigation

✅ **Fixed Header**
- Header row remains visible when scrolling vertically
- Customizable header styling and colors

✅ **Adjustable Dimensions**
- Configurable column widths (with min/max constraints)
- Adjustable row heights
- Custom header height

✅ **Pinnable Columns**
- Pin columns to the left side (future enhancement)
- Pin columns to the right side (future enhancement)

✅ **Custom Cell Widgets**
- Each cell can contain any Flutter widget
- Support for text, chips, containers, icons, and more

✅ **Grid Lines**
- Show/hide grid lines (all, horizontal only, vertical only, or none)
- Customizable grid line color and width

✅ **Text Overflow**
- Automatic ellipsis for overflowing text
- Can be enabled/disabled per table

✅ **Row Styling**
- Alternate row colors for striped effect
- Custom row background colors
- Per-row height customization

✅ **Pagination**
- Built-in pagination support
- Configurable rows per page
- Page navigation controls
- Item count display

✅ **Builder Pattern**
- Support for data list or builder function
- Flexible data source options

✅ **Clean Design**
- Flat, minimal design by default
- All styling customizable by user
- Material Design 3 compatible

## Installation

Since this is a local package in the SmartChuo monorepo, add it to your project's `pubspec.yaml`:

```yaml
dependencies:
  ftable:
    path: ../ftable
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:ftable/ftable.dart';

class MyTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Table')),
      body: FlexibleTable(
        columns: [
          TableColumn(
            key: 'id',
            label: 'ID',
            width: 80,
          ),
          TableColumn(
            key: 'name',
            label: 'Name',
            width: 200,
          ),
          TableColumn(
            key: 'email',
            label: 'Email',
            width: 250,
          ),
        ],
        data: [
          TableRowData(
            cells: {
              'id': Text('1'),
              'name': Text('John Doe'),
              'email': Text('john@example.com'),
            },
          ),
        ],
      ),
    );
  }
}
```

### Table with Pagination

```dart
FlexibleTable(
  columns: myColumns,
  data: myData,
  config: TableConfig(
    enablePagination: true,
    rowsPerPage: 10,
    rowsPerPageOptions: [10, 25, 50, 100],
    showItemCount: true,
  ),
)
```

### Striped Table

```dart
FlexibleTable(
  columns: myColumns,
  data: myData,
  config: TableConfig(
    rowColor: Colors.white,
    alternateRowColor: Colors.grey[100],
    headerBackgroundColor: Colors.blue,
    headerTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

## API Reference

### FlexibleTable

Main widget for displaying the table.

**Properties:**
- `columns` (required): List of TableColumn definitions
- `data`: List of TableRowData (either this or dataBuilder required)
- `dataBuilder`: Function that returns list of TableRowData
- `config`: TableConfig object for customization
- `onRowTap`: Callback when a row is tapped
- `onColumnResize`: Callback when column is resized (future)

### TableColumn

Defines a column in the table.

**Properties:**
- `key` (required): Unique identifier for the column
- `label` (required): Display label for the header
- `width`: Column width in pixels (default: 150)
- `minWidth`: Minimum width constraint (default: 50)
- `maxWidth`: Maximum width constraint
- `alignment`: Content alignment (default: Alignment.centerLeft)

### TableRowData

Represents a data row in the table.

**Properties:**
- `id`: Unique identifier for the row
- `cells` (required): Map of column key to Widget
- `backgroundColor`: Custom background color
- `height`: Custom row height
- `onTap`: Tap callback for this row

### TableConfig

Configuration options for the table.

**Properties:**
- `rowHeight`: Default row height (default: 48)
- `headerHeight`: Header row height (default: 56)
- `headerBackgroundColor`: Header background color
- `headerTextStyle`: Text style for header cells
- `rowColor`: Primary row background color
- `alternateRowColor`: Alternate row background color
- `gridLineColor`: Border color (default: Color(0xFFE0E0E0))
- `gridLineWidth`: Width of grid lines (default: 1.0)
- `gridLineDisplay`: Which grid lines to show
- `enablePagination`: Enable pagination (default: false)
- `rowsPerPage`: Rows per page (default: 10)
- `cellPadding`: Padding inside cells
- `enableEllipsis`: Auto-ellipsis (default: true)

## Examples

Run the example app:

```bash
cd ftable
flutter run
```

The example includes 6 table configurations demonstrating different features.

## Part of SmartChuo Monorepo

This widget is a reusable component within the SmartChuo college management system.
