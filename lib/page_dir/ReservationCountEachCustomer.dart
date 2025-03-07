import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerReservations extends StatefulWidget {
  const CustomerReservations({super.key});

  @override
  State<CustomerReservations> createState() => _CustomerReservationsState();
}

class _CustomerReservationsState extends State<CustomerReservations> {
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomerReservations();
  }

  Future<void> fetchCustomerReservations() async {
    final url = Uri.parse('http://localhost:3000/customer-reservations');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(json.decode(response.body));
        print('Response Data: $responseBody'); // Debugging print

        setState(() {
          _customers = responseBody;
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
      appBar: AppBar(title: const Text('Total Reservations per Customer', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _customers.isEmpty
          ? const Center(child: Text('No reservation data found'))
          : SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Total Reservations', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _customers.map((customer) {
              return DataRow(cells: [
                DataCell(Text(customer['customer_name'].toString())),
                DataCell(Text(customer['Total_Reservations'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
