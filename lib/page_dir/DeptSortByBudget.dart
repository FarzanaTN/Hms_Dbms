import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Deptsortbybudget extends StatefulWidget {
  const Deptsortbybudget({super.key});

  @override
  State<Deptsortbybudget> createState() => _DeptsortbybudgetState();
}

class _DeptsortbybudgetState extends State<Deptsortbybudget> {
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeptSortByBudget();
  }

  Future<void> fetchDeptSortByBudget() async {
    final url = Uri.parse('http://localhost:3000/dept-sort-by-budget');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _departments = List<Map<String, dynamic>>.from(json.decode(response.body));
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
      appBar: AppBar(title: const Text('Departments Sorted by Budget')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _departments.isEmpty
          ? const Center(child: Text('No department data found'))
          : SingleChildScrollView(
        //scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
           // border: TableBorder.all(), // Adds borders for clarity
            columns: const [
              DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Budget', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _departments.map((dept) {
              return DataRow(cells: [
                DataCell(Text(dept['name'].toString())),
                DataCell(Text(dept['budget'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
