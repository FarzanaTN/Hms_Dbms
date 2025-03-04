import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepartmentPage extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  List<dynamic> departments = [];
  String selectedAction = "View"; // Default action is "View"
  String? departmentName;
  String? departmentBudget;

  @override
  void initState() {
    super.initState();
    fetchDepartments(); // Fetch data on load
  }

  // Fetch all departments
  Future<void> fetchDepartments() async {
    final response = await http.get(Uri.parse('http://localhost:3000/department'));
    if (response.statusCode == 200) {
      setState(() {
        departments = json.decode(response.body);
      });
    } else {
      print('Failed to fetch departments');
    }
  }

  // Sort departments by name in ascending order
  Future<void> fetchDepartmentsSortByName() async {
    final response = await http.get(Uri.parse('http://localhost:3000/department'));

    if (response.statusCode == 200) {
      List<dynamic> sortedDepartments = json.decode(response.body);

      // Sort departments by budget in ascending order
      sortedDepartments.sort((a, b) =>
          double.parse(a['budget'].toString()).compareTo(double.parse(b['budget'].toString()))
      );

      setState(() {
        departments = sortedDepartments;
        selectedAction = "View";
      });
    } else {
      print('Failed to fetch departments');
    }
  }



  // Search departments by name
  void searchDepartments() async {
    try {
      // Always fetch fresh data to search through entire dataset
      final response = await http.get(Uri.parse('http://localhost:3000/department'));

      if (response.statusCode == 200) {
        List<dynamic> allDepartments = json.decode(response.body);

        setState(() {
          departments = allDepartments.where((dept) {
            return dept['name'].toLowerCase().contains(departmentName!.toLowerCase());
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search departments')),
        );
      }
    } catch (e) {
      print('Error searching departments: $e');
    }
  }

  // Add a department
  Future<void> addDepartment(String name, String budget) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/department'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'budget': budget}),
    );

    if (response.statusCode == 201) {
      print('Department added successfully');
      fetchDepartments(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to add department');
    }
  }

  Future<void> deleteDepartment(String name) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/department/$name'), // Use URL params
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Department deleted successfully');
      fetchDepartments(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to delete department');
    }
  }



  Future<void> updateDepartment(String name, String budget) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/department'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'budget': budget}), // Ensure both are sent
    );

    if (response.statusCode == 200) {
      print('Department updated successfully');
      fetchDepartments(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to update department');
    }
  }


  // Handle action based on selected radio button
  void handleAction() {
    if (selectedAction == "Add") {
      if (departmentName != null && departmentBudget != null) {
        _showConfirmationDialog(
          "Add Department",
          "Are you sure you want to add the department?",
              () => addDepartment(departmentName!, departmentBudget!),
        );
      } else {
        print("Please provide valid inputs for Add");
      }
    } else if (selectedAction == "Delete") {
      if (departmentName != null) {
        _showConfirmationDialog(
          "Delete Department",
          "Are you sure you want to delete the department?",
              () => deleteDepartment(departmentName!),
        );
      } else {
        print("Please provide a valid department name for Delete");
      }
    } else if (selectedAction == "Update") {
      if (departmentName != null && departmentBudget != null) {
        _showConfirmationDialog(
          "Update Department",
          "Are you sure you want to update the department?",
              () => updateDepartment(departmentName!, departmentBudget!),
        );
      }
      else {
        print("Please provide valid inputs for Update");
      }
    }
    else if (selectedAction == "Sort") {
      fetchDepartmentsSortByName();
      // Automatically switch to View to show results
      selectedAction = "View";
    }  else if (selectedAction == "Search") {
      if (departmentName != null && departmentName!.isNotEmpty) {
        searchDepartments();
        selectedAction = "View";
      } else {
        fetchDepartments(); // Reset to full list if search is empty
      }
    }
  }

  // Function to show a confirmation dialog
  void _showConfirmationDialog(String title, String message, Function() onConfirm) {
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
      departmentName = null;
      departmentBudget = null;
    });
  }

  // Reset fields when switching actions
  void _resetFields() {
    setState(() {
      departmentName = null;
      departmentBudget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Department Management",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Radio buttons for selecting actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      fetchDepartmentsSortByName(); // Directly call sorting method
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

            // Form for Add, Delete, or Update actions
            if (selectedAction == "Add" || selectedAction == "Update") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Department Name",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  departmentName = value;
                },
                controller: TextEditingController(text: departmentName),
              ),

                SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Department Budget",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  departmentBudget = value;
                },
                controller: TextEditingController(text: departmentBudget),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Submit"),
              ),
            ],

            if (selectedAction == "Delete") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Department Name",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  departmentName = value;
                },
                controller: TextEditingController(text: departmentName),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Submit"),
              ),
            ],
            if (selectedAction == "Search") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Search Department Name",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  departmentName = value;
                },
                controller: TextEditingController(text: departmentName),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Search"),
              ),
            ],


            // Table-like structure for department information
            if (selectedAction == "View") ...[
              SizedBox(height: 20),
              // Text(
              //   "Department List",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              // ),
              // SizedBox(height: 10),
              DataTable(
                columns: [
                  DataColumn(label: Text("Department Name")),
                  DataColumn(label: Text("Budget")),
                ],
                rows: departments
                    .map<DataRow>((dept) => DataRow(cells: [
                  DataCell(Text(dept['name'])),
                  DataCell(Text(dept['budget'].toString())),
                ]))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
