import 'package:flutter/material.dart';
import 'package:hotel_dbms/page_dir/employee.dart';
import 'package:hotel_dbms/page_dir/room.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'department.dart';



class AdminSection extends StatefulWidget {
  @override
  _AdminSection createState() => _AdminSection();
}

class _AdminSection extends State<AdminSection> {
  String _selectedMenu = "Dashboard"; // Tracks the current menu
  String _employeeFilter =
      "All"; // Tracks the current employee filter (All/Driver)
  List<Map<String, dynamic>> _data = []; // Stores fetched data
  bool _isLoading = false;

  // Fetch data from the Node.js API
  Future<void> fetchData(String endpoint) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/$endpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = json.decode(response.body);
        setState(() {
          _data = fetchedData.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
      setState(() {
        _data = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRoomForm({Map<String, dynamic>? room}) {
    final TextEditingController roomIdController =
        TextEditingController(text: room?['room_id']?.toString() ?? '');
    final TextEditingController priceController =
        TextEditingController(text: room?['price']?.toString() ?? '');
    final TextEditingController profitController =
        TextEditingController(text: room?['profit_per_room']?.toString() ?? '');

    String status = room?['status'] ?? 'clean';
    String available = room?['available'] ?? 'yes';
    String type = room?['type'] ?? 'single bed';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(room == null ? 'Add Room' : 'Edit Room'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: roomIdController,
                  decoration: InputDecoration(labelText: 'Room ID'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  onChanged: (newValue) {
                    status = newValue!;
                  },
                  items: ['clean', 'dirty']
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Status'),
                ),
                DropdownButtonFormField<String>(
                  value: available,
                  onChanged: (newValue) {
                    available = newValue!;
                  },
                  items: ['yes', 'no']
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Available'),
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  onChanged: (newValue) {
                    type = newValue!;
                  },
                  items: ['single bed', 'double bed']
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: profitController,
                  decoration: InputDecoration(labelText: 'Profit per Room'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final roomData = {
                  'room_id': int.parse(roomIdController.text),
                  'status': status,
                  'available': available,
                  'type': type,
                  'price': double.parse(priceController.text),
                  'profit_per_room': double.parse(profitController.text),
                };

                final url = Uri.parse(
                    'http://localhost:3000/rooms'); // Make sure the backend is running

                try {
                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode(roomData),
                  );

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Navigator.pop(context); // Close the form
                    fetchData(
                        'rooms'); // Refresh room data to show the new room
                  } else {
                    print('Failed to save room: ${response.body}');
                  }
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Text(room == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Menu
          Container(
            width: 200,
            color: Colors.blue[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeader(
                  child: Text(
                    'Menu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(color: Colors.blue),
                ),
                ListTile(
                  leading: Icon(Icons.meeting_room),
                  title: Text('Rooms'),
                  onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomPage(),
                        ),
                      );
                    // Fetch room data
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.people),
                //   title: Text('Employees'),
                //   onTap: () {
                //     setState(() {
                //       _selectedMenu = "Employees";
                //       _employeeFilter = "All"; // Reset filter
                //     });
                //     fetchData("employees"); // Fetch all employee data
                //   },
                // ),

                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Employees'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeePage(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Departments'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepartmentPage(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Customers'),
                  onTap: () {
                    setState(() {
                      _selectedMenu = "Employees";
                      _employeeFilter = "All"; // Reset filter
                    });
                    fetchData("customers"); // Fetch all employee data
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Reservations'),
                  onTap: () {
                    setState(() {
                      _selectedMenu = "Employees";
                      _employeeFilter = "All"; // Reset filter
                    });
                    fetchData("reservations"); // Fetch all employee data
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Payments'),
                  onTap: () {
                    setState(() {
                      _selectedMenu = "Employees";
                      _employeeFilter = "All"; // Reset filter
                    });
                    fetchData("payments"); // Fetch all employee data
                  },
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _data.isEmpty
                      ? Center(
                          child: Text(
                            "No data available. Select a menu item.",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_selectedMenu Data',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            if (_selectedMenu == "Rooms")
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _showRoomForm(),
                                    child: Text('Add Room'),
                                  ),
                                ],
                              ),
                            SizedBox(height: 16),
                            if (_selectedMenu == "Employees")
                              Column(
                                children: [
                                  RadioListTile<String>(
                                    title: Text("All Employees"),
                                    value: "All",
                                    groupValue: _employeeFilter,
                                    onChanged: (value) {
                                      setState(() {
                                        _employeeFilter = value!;
                                      });
                                      fetchData(
                                          "employees"); // Fetch all employees
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: Text("Drivers"),
                                    value: "Drivers",
                                    groupValue: _employeeFilter,
                                    onChanged: (value) {
                                      setState(() {
                                        _employeeFilter = value!;
                                      });
                                      fetchData("drivers"); // Fetch drivers
                                    },
                                  ),
                                ],
                              ),
                            // if (_selectedMenu == "Department")
                            //   Row(
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () => _addDepartment(),
                            //         child: Text("Add Department"),
                            //       ),
                            //       SizedBox(width: 10),
                            //       ElevatedButton(
                            //         onPressed: () => _deleteDepartment(),
                            //         child: Text("Delete Department"),
                            //       ),
                            //       SizedBox(width: 10),
                            //       ElevatedButton(
                            //         onPressed: () => _updateDepartment(),
                            //         child: Text("Update Department"),
                            //       ),
                            //     ],
                            //   ),
                            //
                            // SizedBox(height: 16),
                            // if (_selectedMenu == "Departments")
                            //   Row(
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () => _showRoomForm(),
                            //         child: Text('Add Room'),
                            //       ),
                            //     ],
                            //   ),
                            // SizedBox(height: 16),
                            // if (_selectedMenu == "Customers")
                            //   Row(
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () => _showRoomForm(),
                            //         child: Text('Add Room'),
                            //       ),
                            //     ],
                            //   ),
                            // SizedBox(height: 16),
                            // if (_selectedMenu == "Reservations")
                            //   Row(
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () => _showRoomForm(),
                            //         child: Text('Add Room'),
                            //       ),
                            //     ],
                            //   ),
                            // if (_selectedMenu == "Payments")
                            //   Row(
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () => _showRoomForm(),
                            //         child: Text('Add Room'),
                            //       ),
                            //     ],
                            //   ),
                            // SizedBox(height: 16),
                            // Expanded(
                            //     child: SingleChildScrollView(
                            //       scrollDirection: Axis.horizontal,
                            //       child: DataTable(
                            //         columns: _data.isNotEmpty
                            //             ? _data[0]
                            //             .keys
                            //             .map((key) => DataColumn(
                            //           label: Text(
                            //             key,
                            //             style: TextStyle(
                            //                 fontWeight:
                            //                 FontWeight.bold),
                            //           ),
                            //         ))
                            //             .toList()
                            //             : [],
                            //         rows: _data
                            //             .map((row) => DataRow(
                            //           cells: row.values
                            //               .map((value) => DataCell(
                            //             Text(value.toString()),
                            //           ))
                            //               .toList(),
                            //         ))
                            //             .toList(),
                            //       ),
                            //     ),
                            // ),

                            SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: _data.isNotEmpty
                                      ? _data[0]
                                          .keys
                                          .map((key) => DataColumn(
                                                label: Text(
                                                  key,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))
                                          .toList()
                                      : [],
                                  rows: _data
                                      .map((row) => DataRow(
                                            cells: row.values
                                                .map((value) => DataCell(
                                                      Text(value.toString()),
                                                    ))
                                                .toList(),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}



