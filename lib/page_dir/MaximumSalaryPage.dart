import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MaximumSalaryPage extends StatefulWidget {
  @override
  _MaximumSalaryPageState createState() => _MaximumSalaryPageState();
}

class _MaximumSalaryPageState extends State<MaximumSalaryPage> {
  List<Map<String, dynamic>> _salaryData = [];
  bool _isLoading = false;

  // Fetch Maximum Salary Data
  Future<void> fetchSalaryData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/maximumSalary')); // Replace with your backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _salaryData = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch maximum salary data');
      }
    } catch (e) {
      print('Error fetching maximum salary data: $e');
      setState(() {
        _salaryData = [];
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
    fetchSalaryData(); // Fetch data on initialization
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
            'Maximum Salary of Each Department with Employee Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _salaryData.isNotEmpty
                    ? _salaryData[0]
                    .keys
                    .map((key) => DataColumn(
                  label: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList()
                    : [],
                rows: _salaryData
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
