import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentCustomersPage extends StatefulWidget {
  @override
  _CurrentCustomersPageState createState() => _CurrentCustomersPageState();
}

class _CurrentCustomersPageState extends State<CurrentCustomersPage> {
  List<Map<String, dynamic>> _currentCustomers = [];
  bool _isLoading = false;

  // Fetch Current Customers Data
  Future<void> fetchCurrentCustomers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/currentCustomers')); // Replace with your backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _currentCustomers = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch current customers');
      }
    } catch (e) {
      print('Error fetching current customers: $e');
      setState(() {
        _currentCustomers = [];
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
    fetchCurrentCustomers(); // Fetch data on initialization
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
            'Current Customer Details',
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
                columns: _currentCustomers.isNotEmpty
                    ? _currentCustomers[0]
                    .keys
                    .map((key) => DataColumn(
                  label: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList()
                    : [],
                rows: _currentCustomers
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
