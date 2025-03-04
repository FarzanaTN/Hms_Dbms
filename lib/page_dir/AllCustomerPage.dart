import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomerPage> {
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;

  // Fetch Customer Data
  Future<void> fetchCustomers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/customers')); // Backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _customers = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch customer data');
      }
    } catch (e) {
      print('Error fetching customer data: $e');
      setState(() {
        _customers = [];
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
    fetchCustomers(); // Fetch data on initialization
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
            'Customer Details',
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
                columns: _customers.isNotEmpty
                    ? _customers[0]
                    .keys
                    .map((key) => DataColumn(
                  label: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList()
                    : [],
                rows: _customers
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
