# FlexibleTable Quick Reference

## Basic Setup

```dart
import 'package:ftable/ftable.dart';

FlexibleTable(
  columns: [...],
  data: [...],
  config: TableConfig(...),
)
```

## Common Configurations

### Minimal Table
```dart
FlexibleTable(
  columns: [
    TableColumn(key: 'name', label: 'Name', width: 200),
  ],
  data: [
    TableRowData(cells: {'name': Text('John')}),
  ],
)
```

### Paginated Table
```dart
config: TableConfig(
  enablePagination: true,
  rowsPerPage: 10,
  rowsPerPageOptions: [10, 25, 50],
)
```

### Striped Table
```dart
config: TableConfig(
  rowColor: Colors.white,
  alternateRowColor: Colors.grey[100],
)
```

### No Grid Lines
```dart
config: TableConfig(
  gridLineDisplay: GridLineDisplay.none,
)
```

### Custom Header
```dart
TableColumn(
  key: 'actions',
  label: 'Actions',
  headerBuilder: (context) => Row(
    children: [Icon(Icons.settings), Text('Actions')],
  ),
)
```

## Grid Line Options

- `GridLineDisplay.all` - All grid lines
- `GridLineDisplay.horizontal` - Horizontal only
- `GridLineDisplay.vertical` - Vertical only
- `GridLineDisplay.none` - No grid lines

## Cell Widgets

```dart
cells: {
  'text': Text('Simple text'),
  'chip': Chip(label: Text('Status')),
  'icon': Icon(Icons.check),
  'button': IconButton(icon: Icon(Icons.edit), onPressed: () {}),
  'custom': Container(
    padding: EdgeInsets.all(8),
    child: Text('Custom'),
  ),
}
```

## Key Properties

### TableColumn
- `key` (required) - Unique identifier
- `label` (required) - Header text
- `width` - Column width (default: 150)
- `alignment` - Content alignment

### TableRowData
- `id` - Row identifier
- `cells` (required) - Map of widgets
- `backgroundColor` - Row color
- `onTap` - Tap handler

### TableConfig
- `rowHeight` - Row height (default: 48)
- `headerHeight` - Header height (default: 56)
- `enablePagination` - Enable pagination
- `rowsPerPage` - Items per page (default: 10)
- `gridLineDisplay` - Grid line mode
- `cellPadding` - Cell padding

## Events

```dart
FlexibleTable(
  onRowTap: (row) {
    print('Tapped: ${row.id}');
  },
)
```

## Alignment Options

- `Alignment.centerLeft` (default)
- `Alignment.center`
- `Alignment.centerRight`
- `Alignment.topLeft`
- `Alignment.bottomRight`
