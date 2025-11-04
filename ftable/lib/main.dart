import 'package:flutter/material.dart';
import 'ftable.dart';

void main() {
  runApp(const MyApp());
}

/// Example application demonstrating the FlexibleTable widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexible Table Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FlexibleTableDemo(),
    );
  }
}

/// Demo page showcasing various table configurations
class FlexibleTableDemo extends StatefulWidget {
  const FlexibleTableDemo({super.key});

  @override
  State<FlexibleTableDemo> createState() => _FlexibleTableDemoState();
}

class _FlexibleTableDemoState extends State<FlexibleTableDemo> {
  int _selectedDemo = 0;

  final List<String> _demoTitles = [
    'Basic Table',
    'Table with Pagination',
    'Striped Table',
    'No Grid Lines',
    'Custom Styling',
    'Large Dataset',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexible Table Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Table Examples',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...List.generate(_demoTitles.length, (index) {
              return ListTile(
                title: Text(_demoTitles[index]),
                selected: _selectedDemo == index,
                onTap: () {
                  setState(() {
                    _selectedDemo = index;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _demoTitles[_selectedDemo],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildSelectedDemo()),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDemo() {
    switch (_selectedDemo) {
      case 0:
        return _buildBasicTable();
      case 1:
        return _buildPaginatedTable();
      case 2:
        return _buildStripedTable();
      case 3:
        return _buildNoGridLinesTable();
      case 4:
        return _buildCustomStyledTable();
      case 5:
        return _buildLargeDatasetTable();
      default:
        return _buildBasicTable();
    }
  }

  Widget _buildBasicTable() {
    return FlexibleTable(
      columns: _createBasicColumns(),
      data: _createSampleData(10),
      config: const TableConfig(
        headerBackgroundColor: Colors.blueGrey,
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaginatedTable() {
    return FlexibleTable(
      columns: _createBasicColumns(),
      data: _createSampleData(50),
      config: const TableConfig(
        enablePagination: true,
        rowsPerPage: 10,
        rowsPerPageOptions: [5, 10, 25, 50],
        headerBackgroundColor: Colors.indigo,
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStripedTable() {
    return FlexibleTable(
      columns: _createBasicColumns(),
      data: _createSampleData(20),
      config: TableConfig(
        rowColor: Colors.white,
        alternateRowColor: Colors.grey[100],
        headerBackgroundColor: Colors.teal,
        headerTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNoGridLinesTable() {
    return FlexibleTable(
      columns: _createBasicColumns(),
      data: _createSampleData(15),
      config: TableConfig(
        gridLineDisplay: GridLineDisplay.none,
        rowColor: Colors.white,
        alternateRowColor: Colors.blue[50],
        headerBackgroundColor: Colors.blue,
        headerTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCustomStyledTable() {
    return FlexibleTable(
      columns: _createCustomStyledColumns(),
      data: _createSampleData(12),
      config: TableConfig(
        rowHeight: 60.0,
        headerHeight: 70.0,
        cellPadding: const EdgeInsets.all(12.0),
        gridLineColor: Colors.purple[200]!,
        gridLineWidth: 2.0,
        headerBackgroundColor: Colors.purple[700],
        headerTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildLargeDatasetTable() {
    return FlexibleTable(
      columns: _createExtendedColumns(),
      data: _createSampleData(200),
      config: const TableConfig(
        enablePagination: true,
        rowsPerPage: 25,
        rowsPerPageOptions: [10, 25, 50, 100],
        headerBackgroundColor: Colors.deepOrange,
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<TableColumn> _createBasicColumns() {
    return [
      const TableColumn(
        key: 'id',
        label: 'ID',
        width: 80,
        alignment: Alignment.center,
      ),
      const TableColumn(key: 'name', label: 'Name', width: 200),
      const TableColumn(key: 'email', label: 'Email', width: 250),
      const TableColumn(key: 'role', label: 'Role', width: 150),
      const TableColumn(
        key: 'status',
        label: 'Status',
        width: 120,
        alignment: Alignment.center,
      ),
    ];
  }

  List<TableColumn> _createCustomStyledColumns() {
    return [
      TableColumn(
        key: 'id',
        label: 'ID',
        width: 80,
        alignment: Alignment.center,
        headerBuilder: (context) => const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tag, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text(
              'ID',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      const TableColumn(key: 'name', label: 'Name', width: 200),
      const TableColumn(key: 'department', label: 'Department', width: 180),
      const TableColumn(
        key: 'salary',
        label: 'Salary',
        width: 150,
        alignment: Alignment.centerRight,
      ),
    ];
  }

  List<TableColumn> _createExtendedColumns() {
    return [
      const TableColumn(
        key: 'id',
        label: 'ID',
        width: 80,
        alignment: Alignment.center,
      ),
      const TableColumn(key: 'name', label: 'Full Name', width: 200),
      const TableColumn(key: 'email', label: 'Email Address', width: 250),
      const TableColumn(key: 'phone', label: 'Phone', width: 150),
      const TableColumn(key: 'department', label: 'Department', width: 150),
      const TableColumn(key: 'role', label: 'Role', width: 150),
      const TableColumn(key: 'joinDate', label: 'Join Date', width: 120),
    ];
  }

  List<TableRowData> _createSampleData(int count) {
    final departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance'];
    final roles = [
      'Manager',
      'Developer',
      'Designer',
      'Analyst',
      'Coordinator',
    ];
    final statuses = ['Active', 'Inactive', 'On Leave'];

    return List.generate(count, (index) {
      final id = (index + 1).toString();
      final name = 'User ${index + 1}';
      final email = 'user${index + 1}@example.com';
      final phone = '+1 555-${(1000 + index).toString()}';
      final department = departments[index % departments.length];
      final role = roles[index % roles.length];
      final status = statuses[index % statuses.length];
      final joinDate =
          '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-01';

      return TableRowData(
        id: id,
        cells: {
          'id': Text(id, style: const TextStyle(fontWeight: FontWeight.w500)),
          'name': Text(name),
          'email': Text(email),
          'phone': Text(phone),
          'department': Chip(
            label: Text(department, style: const TextStyle(fontSize: 12)),
            backgroundColor: _getDepartmentColor(department),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          'role': Text(role),
          'status': Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          'joinDate': Text(joinDate),
          'salary': Text(
            '\$${((index + 1) * 1000 + 50000).toString()}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        },
      );
    });
  }

  Color _getDepartmentColor(String department) {
    switch (department) {
      case 'Engineering':
        return Colors.blue[100]!;
      case 'Sales':
        return Colors.green[100]!;
      case 'Marketing':
        return Colors.orange[100]!;
      case 'HR':
        return Colors.purple[100]!;
      case 'Finance':
        return Colors.teal[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.red;
      case 'On Leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
