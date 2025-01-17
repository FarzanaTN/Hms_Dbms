import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SQLTable extends StatefulWidget {
  @override
  _SQLTableState createState() => _SQLTableState();
}

class _SQLTableState extends State<SQLTable> {
  List<dynamic> _data = [];

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost:3000/query'); // Backend URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQL Query Result')),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _data.isNotEmpty
              ? (_data[0].keys.map<DataColumn>((key) => DataColumn(label: Text(key))).toList())
              : [],
          rows: _data
              .map<DataRow>((row) => DataRow(
            cells: row.values
                .map<DataCell>((value) => DataCell(Text(value.toString())))
                .toList(),
          ))
              .toList(),
        ),
      )

    );
  }
}

void main() {
  runApp(MaterialApp(home: SQLTable()));
}
