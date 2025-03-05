import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Deptavgsalary extends StatefulWidget {
  const Deptavgsalary({super.key});

  @override
  State<Deptavgsalary> createState() => _DeptavgsalaryState();
}

class _DeptavgsalaryState extends State<Deptavgsalary> {
  List<Map<String, dynamic>> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDeptAvgSalary();
  }



  Future<void> fetchDeptAvgSalary() async {
    final url = Uri.parse('http://localhost:3000/dept-avg-salary');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Response Data: $responseBody'); // Debugging print

        // Convert avg_salary to double
        setState(() {
          _departments = responseBody.map((dept) {
            dept['avg_salary'] = double.tryParse(dept['avg_salary'].toString()) ?? 0.0; // Parse to double
            return dept;
          }).toList();
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
      appBar: AppBar(title: const Text('Department Average Salary')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _departments.isEmpty
          ? const Center(child: Text('No department salary data found'))
          : SingleChildScrollView(
        child: Align( // Align widget to center horizontally
          alignment: Alignment.center,
          child: DataTable(
           // border: TableBorder.all(), // Adds borders for clarity
            columns: const [
              DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Avg Salary', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _departments.map((dept) {
              return DataRow(cells: [
                DataCell(Text(dept['dept_name'].toString())),
                DataCell(Text(dept['avg_salary'].toStringAsFixed(2))), // Format salary to 2 decimal places
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }




}
