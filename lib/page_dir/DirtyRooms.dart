import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dirtyrooms extends StatefulWidget {
  const Dirtyrooms({super.key});

  @override
  State<Dirtyrooms> createState() => _DirtyroomsState();
}

class _DirtyroomsState extends State<Dirtyrooms> {
  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDirtyRooms();
  }

  Future<void> fetchDirtyRooms() async {
    final url = Uri.parse('http://localhost:3000/dirty-rooms');

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
      appBar: AppBar(title: const Text('Dirty Rooms')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
          ? const Center(child: Text('No dirty rooms found'))
          : SingleChildScrollView(
        //scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
           // border: TableBorder.all(), // Adds borders for clarity
            columns: const [
              DataColumn(label: Text('Room ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: _rooms.map((room) {
              return DataRow(cells: [
                DataCell(Text(room['room_id'].toString())),
                DataCell(Text(room['type'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
