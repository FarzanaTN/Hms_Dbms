import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Availablerooms extends StatefulWidget {
  const Availablerooms({super.key});

  @override
  State<Availablerooms> createState() => _AvailableroomsState();
}

class _AvailableroomsState extends State<Availablerooms> {
  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailableRooms();
  }

  Future<void> fetchAvailableRooms() async {
    final url = Uri.parse('http://localhost:3000/available-rooms');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _rooms = List<Map<String, dynamic>>.from(json.decode(response.body));
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
      appBar: AppBar(title: const Text('Available Rooms')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
          ? const Center(child: Text('No available rooms found'))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: DataTable(
          border: TableBorder.all(), // Adds borders for clarity
          columns: const [
            DataColumn(label: Text('Room ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _rooms.map((room) {
            return DataRow(cells: [
              DataCell(Text(room['room_id'].toString())),
              DataCell(Text("\$${room['price']}")), // Formats price with a dollar sign
              DataCell(Text(room['type'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
