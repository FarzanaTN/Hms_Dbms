import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Employeeminusguard extends StatefulWidget {
  const Employeeminusguard({super.key});

  @override
  State<Employeeminusguard> createState() => _EmployeeminusguardState();
}

class _EmployeeminusguardState extends State<Employeeminusguard> {
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  void fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/nonSecurityEmployees'));

      if (response.statusCode == 200) {
        setState(() {
          employees = json.decode(response.body);
        });
      } else {
        print("Failed to load employees: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees Without Security Guard', style: TextStyle(fontWeight: FontWeight.bold),), centerTitle: true,),
      body: employees.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.center,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Employee ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Employee Name', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: employees
                .map((emp) => DataRow(cells: [
              DataCell(Text(emp["emp_id"].toString())),
              DataCell(Text(emp["employee_name"])),
            ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}
