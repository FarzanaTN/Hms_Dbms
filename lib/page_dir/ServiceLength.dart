import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Servicelength extends StatefulWidget {
  const Servicelength({super.key});

  @override
  State<Servicelength> createState() => _ServicelengthState();
}

class _ServicelengthState extends State<Servicelength> {
  List<Map<String, dynamic>> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServiceLength();
  }

  Future<void> fetchServiceLength() async {
    final url = Uri.parse('http://localhost:3000/service-length');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _employees = List<Map<String, dynamic>>.from(json.decode(response.body));
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
      appBar: AppBar(title: const Text('Employee Service Length')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
          ? const Center(child: Text('No data found'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows horizontal scrolling if needed
        child: DataTable(
          border: TableBorder.all(), // Adds table borders
          columns: const [
            DataColumn(label: Text('Emp ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Service Years', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _employees.map((employee) {
            return DataRow(cells: [
              DataCell(Text(employee['emp_id'].toString())),
              DataCell(Text(employee['name'])),
              DataCell(Text(employee['service_years'].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
