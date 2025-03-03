import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Driverdetails extends StatefulWidget {
  const Driverdetails({super.key});

  @override
  State<Driverdetails> createState() => _DriverdetailsState();
}

class _DriverdetailsState extends State<Driverdetails> {
  List<Map<String, dynamic>> _drivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  Future<void> fetchDriverDetails() async {
    final url = Uri.parse('http://localhost:3000/driver-details');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _drivers = List<Map<String, dynamic>>.from(json.decode(response.body));
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
      appBar: AppBar(title: const Text('Driver Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _drivers.isEmpty
          ? const Center(child: Text('No driver data found'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows horizontal scrolling
        child: DataTable(
          border: TableBorder.all(), // Adds borders for clarity
          columns: const [
            DataColumn(label: Text('Emp ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('License', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _drivers.map((driver) {
            return DataRow(cells: [
              DataCell(Text(driver['emp_id'].toString())),
              DataCell(Text(driver['name'] ?? 'N/A')), // Use full_name instead of first_name + last_name
              DataCell(Text(driver['driving_license'] ?? 'N/A')),
              DataCell(Text(driver['experience'].toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
