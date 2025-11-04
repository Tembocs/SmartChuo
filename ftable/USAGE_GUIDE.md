# FlexibleTable Usage Guide

This guide provides comprehensive instructions on how to use the FlexibleTable widget in your Flutter applications.

## Quick Start

### 1. Import the Package

```dart
import 'package:ftable/ftable.dart';
```

### 2. Define Your Columns

```dart
final columns = [
  TableColumn(
    key: 'id',
    label: 'ID',
    width: 80,
    alignment: Alignment.center,
  ),
  TableColumn(
    key: 'name',
    label: 'Full Name',
    width: 200,
  ),
  TableColumn(
    key: 'email',
    label: 'Email Address',
    width: 250,
  ),
];
```

### 3. Prepare Your Data

```dart
final data = [
  TableRowData(
    id: '1',
    cells: {
      'id': Text('1'),
      'name': Text('John Doe'),
      'email': Text('john@example.com'),
    },
  ),
  TableRowData(
    id: '2',
    cells: {
      'id': Text('2'),
      'name': Text('Jane Smith'),
      'email': Text('jane@example.com'),
    },
  ),
];
```

### 4. Create the Table

```dart
FlexibleTable(
  columns: columns,
  data: data,
)
```

## Advanced Features

### Pagination

Enable pagination for large datasets:

```dart
FlexibleTable(
  columns: columns,
  data: data,
  config: TableConfig(
    enablePagination: true,
    rowsPerPage: 10,
    rowsPerPageOptions: [5, 10, 25, 50, 100],
    showItemCount: true,
  ),
)
```

### Styling

#### Header Styling

```dart
config: TableConfig(
  headerHeight: 60.0,
  headerBackgroundColor: Colors.blue,
  headerTextStyle: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
)
```

#### Row Styling

```dart
config: TableConfig(
  rowHeight: 50.0,
  rowColor: Colors.white,
  alternateRowColor: Colors.grey[100],
)
```

#### Grid Lines

```dart
// Show all grid lines
config: TableConfig(
  gridLineDisplay: GridLineDisplay.all,
  gridLineColor: Colors.grey[300],
  gridLineWidth: 1.0,
)

// Show only horizontal lines
config: TableConfig(
  gridLineDisplay: GridLineDisplay.horizontal,
)

// Show only vertical lines
config: TableConfig(
  gridLineDisplay: GridLineDisplay.vertical,
)

// Hide all grid lines
config: TableConfig(
  gridLineDisplay: GridLineDisplay.none,
)
```

### Custom Cell Widgets

You can use any Flutter widget in table cells:

#### Text with Custom Style

```dart
cells: {
  'name': Text(
    'John Doe',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
  ),
}
```

#### Chips

```dart
cells: {
  'status': Chip(
    label: Text('Active'),
    backgroundColor: Colors.green[100],
  ),
}
```

#### Icons

```dart
cells: {
  'verified': Icon(
    Icons.check_circle,
    color: Colors.green,
  ),
}
```

#### Action Buttons

```dart
cells: {
  'actions': Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => handleEdit(rowData),
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => handleDelete(rowData),
      ),
    ],
  ),
}
```

#### Custom Containers

```dart
cells: {
  'priority': Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'High',
      style: TextStyle(color: Colors.white),
    ),
  ),
}
```

### Row Interactions

#### Handle Row Taps

```dart
FlexibleTable(
  columns: columns,
  data: data,
  onRowTap: (row) {
    print('Tapped row: ${row.id}');
    // Navigate to details page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(rowId: row.id),
      ),
    );
  },
)
```

#### Individual Row Tap Handlers

```dart
TableRowData(
  cells: {...},
  onTap: () {
    print('This specific row was tapped');
  },
)
```

### Dynamic Data with Builder

Use `dataBuilder` when you need to generate data dynamically:

```dart
FlexibleTable(
  columns: columns,
  dataBuilder: (context) {
    // Fetch from database, API, or generate programmatically
    return fetchDataFromDatabase();
  },
  config: config,
)
```

### Custom Column Headers

Create custom header widgets:

```dart
TableColumn(
  key: 'actions',
  label: 'Actions',
  width: 150,
  headerBuilder: (context) => Row(
    children: [
      Icon(Icons.settings, size: 18),
      SizedBox(width: 4),
      Text(
        'Actions',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
)
```

### Column Alignment

Control content alignment within columns:

```dart
TableColumn(
  key: 'price',
  label: 'Price',
  width: 120,
  alignment: Alignment.centerRight, // Right-align prices
)

TableColumn(
  key: 'status',
  label: 'Status',
  width: 100,
  alignment: Alignment.center, // Center-align status badges
)
```

### Cell Padding

Adjust padding within cells:

```dart
config: TableConfig(
  cellPadding: EdgeInsets.all(12.0),
  // or
  cellPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
)
```

### Table Border and Elevation

Add borders and shadow to the table:

```dart
config: TableConfig(
  tableBorder: Border.all(color: Colors.grey, width: 1),
  elevation: 4.0,
  borderRadius: BorderRadius.circular(8.0),
)
```

## Complete Example

Here's a complete example combining multiple features:

```dart
import 'package:flutter/material.dart';
import 'package:ftable/ftable.dart';

class EmployeeTablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FlexibleTable(
          columns: [
            TableColumn(
              key: 'id',
              label: 'ID',
              width: 60,
              alignment: Alignment.center,
            ),
            TableColumn(
              key: 'name',
              label: 'Employee Name',
              width: 200,
            ),
            TableColumn(
              key: 'department',
              label: 'Department',
              width: 150,
            ),
            TableColumn(
              key: 'salary',
              label: 'Salary',
              width: 120,
              alignment: Alignment.centerRight,
            ),
            TableColumn(
              key: 'status',
              label: 'Status',
              width: 100,
              alignment: Alignment.center,
            ),
            TableColumn(
              key: 'actions',
              label: 'Actions',
              width: 120,
              alignment: Alignment.center,
            ),
          ],
          data: _generateEmployeeData(),
          config: TableConfig(
            enablePagination: true,
            rowsPerPage: 10,
            rowsPerPageOptions: [10, 25, 50],
            headerBackgroundColor: Colors.indigo,
            headerTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            rowColor: Colors.white,
            alternateRowColor: Colors.grey[50],
            gridLineColor: Colors.grey[300]!,
            elevation: 2.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          onRowTap: (row) {
            print('Tapped employee ID: ${row.id}');
          },
        ),
      ),
    );
  }

  List<TableRowData> _generateEmployeeData() {
    return [
      TableRowData(
        id: '1',
        cells: {
          'id': Text('1'),
          'name': Text('John Doe'),
          'department': Text('Engineering'),
          'salary': Text('\$75,000'),
          'status': Chip(
            label: Text('Active', style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.green[100],
          ),
          'actions': Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 18),
                onPressed: () {},
              ),
            ],
          ),
        },
      ),
      // Add more employees...
    ];
  }
}
```

## Tips and Best Practices

1. **Column Keys**: Use descriptive, unique keys for columns to avoid confusion.

2. **Width Management**: Set appropriate column widths based on content. Use `minWidth` and `maxWidth` for constraints.

3. **Performance**: For very large datasets (1000+ rows), enable pagination to maintain smooth performance.

4. **Responsive Design**: Consider different screen sizes when setting column widths.

5. **Accessibility**: Use semantic widgets and provide appropriate labels for screen readers.

6. **Consistency**: Keep cell content types consistent within columns for better UX.

7. **Error Handling**: Always provide fallback widgets for missing data:
   ```dart
   cells: {
     'email': Text(email ?? 'N/A'),
   }
   ```

8. **Memory Management**: When using `dataBuilder`, ensure you're not creating unnecessary objects on each rebuild.

## Troubleshooting

### Table Not Showing

- Ensure the table has constraints (wrap in Expanded, SizedBox, or Container with height)
- Verify that `columns` and `data`/`dataBuilder` are not empty

### Overflow Errors

- Check column widths sum doesn't exceed available width
- Enable horizontal scrolling (it's automatic)
- Reduce column widths or number of visible columns

### Pagination Not Working

- Verify `enablePagination: true` in `TableConfig`
- Check that `data` has more rows than `rowsPerPage`

### Styling Not Applied

- Ensure you're passing `TableConfig` correctly
- Check for typos in color values
- Verify Material theme is properly set up in your app
