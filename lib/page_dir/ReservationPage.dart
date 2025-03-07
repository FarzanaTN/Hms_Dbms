import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Map<String, dynamic>> _reservations = [];
  bool _isLoading = false;

  // Fetch Reservation Data
  Future<void> fetchReservations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/reservations')); // Backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _reservations = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch reservation data');
      }
    } catch (e) {
      print('Error fetching reservation data: $e');
      setState(() {
        _reservations = [];
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
    fetchReservations(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(title: Text('Reservations')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 16),
          Center(
            child: Text(
              'Reservation Details',
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
                  columns: [
                    DataColumn(label: Text('Customer ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Reservation ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Room ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  //  DataColumn(label: Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  //  DataColumn(label: Text('Room Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Check-in Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Check-out Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Total Bill', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),

                  ],
                  rows: _reservations
                      .map((row) => DataRow(
                    cells: [
                      DataCell(Text(row['cus_id'].toString())),
                      DataCell(Text(row['r_id'].toString())),
                      DataCell(Text(row['room_id'].toString())),
                    //  DataCell(Text('${row['first_name']} ${row['last_name']}')),
                    //  DataCell(Text(row['room_type'])),
                      DataCell(Text(row['check_in_date'].toString())),
                      DataCell(Text(row['check_out_date'].toString())),
                      DataCell(Text('\$${row['total_bill'].toString()}')),
                      DataCell(Text(row['status'].toString())),


                    ],
                  ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
