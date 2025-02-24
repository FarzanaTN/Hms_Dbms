import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfitPerMonthPage extends StatefulWidget {
  @override
  _ProfitPerMonthPageState createState() => _ProfitPerMonthPageState();
}

class _ProfitPerMonthPageState extends State<ProfitPerMonthPage> {
  List<Map<String, dynamic>> _profitData = [];
  bool _isLoading = false;

  // Fetch Profit Per Month Data
  Future<void> fetchProfitData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/profitPerMonth')); // Replace with your backend endpoint
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _profitData = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch profit data');
      }
    } catch (e) {
      print('Error fetching profit data: $e');
      setState(() {
        _profitData = [];
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
    fetchProfitData(); // Fetch data on initialization
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
            'Profit Per Month',
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
                columns: _profitData.isNotEmpty
                    ? _profitData[0]
                    .keys
                    .map((key) => DataColumn(
                  label: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
                    .toList()
                    : [],
                rows: _profitData
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
