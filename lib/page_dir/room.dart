import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<dynamic> rooms = [];
  String selectedAction = "View"; // Default action is "View"
  String? roomId;
  String? roomStatus;
  String? roomAvailable;
  String? roomType;
  String? roomPrice;
  String? roomProfit;

  @override
  void initState() {
    super.initState();
    fetchRooms(); // Fetch data on load
  }

  // Fetch all rooms
  Future<void> fetchRooms() async {
    final response = await http.get(Uri.parse('http://localhost:3000/rooms'));
    if (response.statusCode == 200) {
      setState(() {
        rooms = json.decode(response.body);
      });
    } else {
      print('Failed to fetch rooms');
    }
  }

  // Sort rooms by price in ascending order
  Future<void> fetchRoomsSortByPrice() async {
    final response = await http.get(Uri.parse('http://localhost:3000/rooms'));

    if (response.statusCode == 200) {
      List<dynamic> sortedRooms = json.decode(response.body);

      // Sort rooms by price in ascending order
      sortedRooms.sort((a, b) => double.parse(a['price'].toString())
          .compareTo(double.parse(b['price'].toString())));

      setState(() {
        rooms = sortedRooms;
        selectedAction = "View";
      });
    } else {
      print('Failed to fetch rooms');
    }
  }

  // Search rooms by type
  void searchRooms() async {
    try {
      // Always fetch fresh data to search through entire dataset
      final response = await http.get(Uri.parse('http://localhost:3000/rooms'));

      if (response.statusCode == 200) {
        List<dynamic> allRooms = json.decode(response.body);

        setState(() {
          rooms = allRooms.where((room) {
            return room['type'].toLowerCase().contains(roomType!.toLowerCase());
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search rooms')),
        );
      }
    } catch (e) {
      print('Error searching rooms: $e');
    }
  }

  // Add a room
  Future<void> addRoom(String id, String status, String available, String type,
      String price, String profit) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/rooms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'room_id': id,
        'status': status,
        'available': available,
        'type': type,
        'price': price,
        'profit_per_room': profit
      }),
    );

    if (response.statusCode == 201) {
      print('Room added successfully');
      fetchRooms(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to add room');
    }
  }

  Future<void> deleteRoom(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/rooms/$id'), // Use URL params
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Room deleted successfully');
      fetchRooms(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to delete room. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  Future<void> updateRoom(
      String id, String status, String available, String price) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/rooms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'room_id': id,
        'status': status,
        'available': available,
        'price': price,
      }),
    );

    if (response.statusCode == 200) {
      print('Room updated successfully');
      fetchRooms(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to update room');
    }
  }

  // Handle action based on selected radio button
  void handleAction() {
    if (selectedAction == "Add") {
      if (roomId != null &&
          roomStatus != null &&
          roomAvailable != null &&
          roomType != null &&
          roomPrice != null &&
          roomProfit != null) {
        _showConfirmationDialog(
          "Add Room",
          "Are you sure you want to add the room?",
          () => addRoom(roomId!, roomStatus!, roomAvailable!, roomType!,
              roomPrice!, roomProfit!),
        );
      } else {
        print("Please provide valid inputs for Add");
      }
    } else if (selectedAction == "Delete") {
      if (roomId != null) {
        _showConfirmationDialog(
          "Delete Room",
          "Are you sure you want to delete the room?",
          () => deleteRoom(roomId!),
        );
      } else {
        print("Please provide a valid room ID for Delete");
      }
    } else if (selectedAction == "Update") {
      if (roomId != null &&
          roomStatus != null &&
          roomAvailable != null &&
          roomPrice != null) {
        _showConfirmationDialog(
          "Update Room",
          "Are you sure you want to update the room?",
          () => updateRoom(roomId!, roomStatus!, roomAvailable!, roomPrice!),
        );
      } else {
        print("Please provide valid inputs for Update");
      }
    } else if (selectedAction == "Sort") {
      fetchRoomsSortByPrice();
      // Automatically switch to View to show results
      selectedAction = "View";
    } else if (selectedAction == "Search") {
      if (roomType != null && roomType!.isNotEmpty) {
        searchRooms();
        selectedAction = "View";
      } else {
        fetchRooms(); // Reset to full list if search is empty
      }
    }
  }

  // Function to show a confirmation dialog
  void _showConfirmationDialog(
      String title, String message, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the function on confirm
                _showSuccessDialog();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Action completed successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to clear form fields
  void _clearFields() {
    setState(() {
      roomId = null;
      roomStatus = null;
      roomAvailable = null;
      roomType = null;
      roomPrice = null;
      roomProfit = null;
    });
  }

  // Reset fields when switching actions
  void _resetFields() {
    setState(() {
      roomId = null;
      roomStatus = null;
      roomAvailable = null;
      roomType = null;
      roomPrice = null;
      roomProfit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Room Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),

        centerTitle: true, // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Radio buttons for selecting actions
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Radio<String>(
                    value: "View",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        _resetFields(); // Reset fields when switching action
                      });
                    },
                  ),
                  Text("View"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: "Add",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        _resetFields(); // Reset fields when switching action
                      });
                    },
                  ),
                  Text("Add"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: "Delete",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        _resetFields(); // Reset fields when switching action
                      });
                    },
                  ),
                  Text("Delete"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: "Update",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        _resetFields(); // Reset fields when switching action
                      });
                    },
                  ),
                  Text("Update"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: "Sort",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        fetchRoomsSortByPrice(); // Directly call sorting method
                      });
                    },
                  ),
                  Text("Sort"),
                  SizedBox(width: 16),
                  Radio<String>(
                    value: "Search",
                    groupValue: selectedAction,
                    onChanged: (value) {
                      setState(() {
                        selectedAction = value!;
                        _resetFields(); // Reset fields when switching action
                      });
                    },
                  ),
                  Text("Search"),
                  SizedBox(width: 16),
                ],
              ),
            ),

            // Form for Add, Delete, or Update actions
            if (selectedAction == "Add") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room ID",
                  border: OutlineInputBorder(),
                 // filled: true,
                ),
                onChanged: (value) {
                  roomId = value;
                },
                controller: TextEditingController(text: roomId),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Room Status",
                  border: OutlineInputBorder(),
                 // filled: true,
                ),
                value: roomStatus,
                items: ['clean', 'dirty'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomStatus = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Room Available",
                  border: OutlineInputBorder(),
                 // filled: true,
                ),
                value: roomAvailable,
                items: ['yes', 'no'].map((available) {
                  return DropdownMenuItem(
                    value: available,
                    child: Text(available),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomAvailable = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Room Type",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                value: roomType,
                items: ['single bed', 'double bed'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomType = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room Price",
                  border: OutlineInputBorder(),
               //   filled: true,
                ),
                onChanged: (value) {
                  roomPrice = value;
                },
                controller: TextEditingController(text: roomPrice),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room Profit",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                onChanged: (value) {
                  roomProfit = value;
                },
                controller: TextEditingController(text: roomProfit),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: handleAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  side: BorderSide(
                    color: Colors.blue[900]!, // Dark blue border for Confirm
                    width: 2.0, // Border width
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.blue[900]!, // Blue font for Confirm
                  ),
                ),
              )
            ],

            if (selectedAction == "Update") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room ID",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                onChanged: (value) {
                  roomId = value;
                },
                controller: TextEditingController(text: roomId),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Room Status",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                value: roomStatus,
                items: ['clean', 'dirty'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomStatus = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Room Available",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                value: roomAvailable,
                items: ['yes', 'no'].map((available) {
                  return DropdownMenuItem(
                    value: available,
                    child: Text(available),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomAvailable = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room Price",
                  border: OutlineInputBorder(),
                 // filled: true,
                ),
                onChanged: (value) {
                  roomPrice = value;
                },
                controller: TextEditingController(text: roomPrice),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: handleAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  side: BorderSide(
                    color: Colors.blue[900]!, // Dark blue border for Confirm
                    width: 2.0, // Border width
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.blue[900]!, // Blue font for Confirm
                  ),
                ),
              )
            ],

            if (selectedAction == "Delete") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Room ID",
                  border: OutlineInputBorder(),
                 // filled: true,
                ),
                onChanged: (value) {
                  roomId = value;
                },
                controller: TextEditingController(text: roomId),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: handleAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  side: BorderSide(
                    color: Colors.blue[900]!, // Dark blue border for Confirm
                    width: 2.0, // Border width
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.blue[900]!, // Blue font for Confirm
                  ),
                ),
              )
            ],

            if (selectedAction == "Search") ...[
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Search Room Type",
                  border: OutlineInputBorder(),
                //  filled: true,
                ),
                value: roomType,
                items: ['single bed', 'double bed'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roomType = value;
                  });
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: handleAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  side: BorderSide(
                    color: Colors.blue[900]!, // Dark blue border for Confirm
                    width: 2.0, // Border width
                  ),
                ),
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.blue[900]!, // Blue font for Confirm
                  ),
                ),
              )
            ],

            // Table-like structure for room information
            // Display the rooms in a table format
            if (selectedAction == "View") ...[
              SizedBox(height: 20),
              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: DataTable(
              //       columns: const [
              //         DataColumn(label: Text('Room ID')),
              //         DataColumn(label: Text('Type')),
              //         DataColumn(label: Text('Status')),
              //         DataColumn(label: Text('Available')),
              //         DataColumn(label: Text('Price')),
              //         DataColumn(label: Text('Profit')),
              //         DataColumn(label: Text('Actions')),
              //       ],
              //       rows: rooms.map<DataRow>((room) {
              //         return DataRow(
              //           cells: [
              //             DataCell(Text(room['room_id'].toString())),
              //             DataCell(Text(room['type'])),
              //             DataCell(Text(room['status'])),
              //             DataCell(Text(room['available'])),
              //             DataCell(Text('\$${room['price']}')),
              //             DataCell(Text('\$${room['profit_per_room']}')),
              //             DataCell(IconButton(
              //               icon: Icon(Icons.delete),
              //               onPressed: () => _showConfirmationDialog(
              //                 "Delete Room",
              //                 "Are you sure you want to delete this room?",
              //                 () => deleteRoom(room['room_id']),
              //               ),
              //             )),
              //           ],
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Vertical scrolling
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Horizontal scrolling
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Room ID')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Available')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Profit')),
                          // DataColumn(label: Text('Actions')),
                        ],
                        rows: rooms.map<DataRow>((room) {
                          return DataRow(
                            cells: [
                              DataCell(Text(room['room_id'].toString())),
                              DataCell(Text(room['type'])),
                              DataCell(Text(room['status'])),
                              DataCell(Text(room['available'])),
                              DataCell(Text('\$${room['price']}')),
                              DataCell(Text('\$${room['profit_per_room']}')),
                              // DataCell(IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () => _showConfirmationDialog(
                              //     "Delete Room",
                              //     "Are you sure you want to delete this room?",
                              //         () => deleteRoom(room['room_id']),
                              //   ),
                              // )
                              // ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
