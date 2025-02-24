import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeCountByDeptPage extends StatefulWidget {
  @override
  _EmployeeCountByDeptPageState createState() => _EmployeeCountByDeptPageState();
}

class _EmployeeCountByDeptPageState extends State<EmployeeCountByDeptPage> {
  List<Map<String, dynamic>> _employeeCounts = [];
  bool _isLoading = false;

  // Fetch Employee Count by Department
  Future<void> fetchEmployeeCounts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/employeeCounts')); // Replace with your backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _employeeCounts = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch employee counts');
      }
    } catch (e) {
      print('Error fetching employee counts: $e');
      setState(() {
        _employeeCounts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEmployeeCounts(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [
        SizedBox(height: 16),
        Center(
          child: Text(
            'Employee Count for Each Department',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _employeeCounts.isNotEmpty
                    ? _employeeCounts[0]
                    .keys
                    .map((key) => DataColumn(
                  label: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList()
                    : [],
                rows: _employeeCounts
                    .map((row) => DataRow(
                  cells: row.values
                      .map((value) => DataCell(Text(value.toString())))
                      .toList(),
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
