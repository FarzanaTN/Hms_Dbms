import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gpuser extends StatefulWidget {
  const Gpuser({super.key});

  @override
  State<Gpuser> createState() => _GpuserState();
}

class _GpuserState extends State<Gpuser> {
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    const String url = 'http://localhost:3000/gpUser'; // Update with your API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          employees = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gp User Employee List", style: TextStyle(fontWeight: FontWeight.bold),), centerTitle: true,),
      body: employees.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Phone')),
            ],
            rows: employees.map((emp) {
              return DataRow(cells: [
                DataCell(Text(emp['emp_id'].toString())),
                DataCell(Text(emp['employee_name'])),
                DataCell(Text(emp['phone'])),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
