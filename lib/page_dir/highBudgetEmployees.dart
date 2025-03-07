import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HighBudgetEmployees extends StatefulWidget {
  const HighBudgetEmployees({super.key});

  @override
  State<HighBudgetEmployees> createState() => _HighBudgetEmployeesState();
}

class _HighBudgetEmployeesState extends State<HighBudgetEmployees> {
  List<Map<String, dynamic>> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHighBudgetEmployees();
  }

  Future<void> fetchHighBudgetEmployees() async {
    final url = Uri.parse('http://localhost:3000/high-budget-employees');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Response Data: $responseBody'); // Debugging print

        setState(() {
          _employees = responseBody;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees in High Budget Departments', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
          ? const Center(child: Text('No employees found'))
          : SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Emp ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('First Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _employees.map((emp) {
              return DataRow(cells: [
                DataCell(Text(emp['emp_id'].toString())),
                DataCell(Text(emp['first_name'].toString())),
                DataCell(Text(emp['last_name'].toString())),
                DataCell(Text(emp['dept_name'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
