import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<dynamic> employees = [];
  String selectedAction = "View"; // Default action is "View"
  String? empId;
  String? firstName;
  String? lastName;
  String? gender;
  String? dateOfBirth;
  String? dateOfJoin;
  String? phone;
  String? email;
  String? houseNo;
  String? streetName;
  String? city;
  String? postalCode;
  String? district;
  String? division;
  String? nid;
  String? deptName;
  String? salary;
  String? serviceLength;
  String? percentageIncrease;

  @override
  void initState() {
    super.initState();
    fetchEmployees(); // Fetch data on load
  }

  // Fetch all employees
  Future<void> fetchEmployees() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/employees'));
    if (response.statusCode == 200) {
      setState(() {
        employees = json.decode(response.body);
      });
    } else {
      print('Failed to fetch employees');
    }
  }

  // Add an employee
  Future<void> addEmployee(
      String id,
      String firstName,
      String lastName,
      String gender,
      String dateOfBirth,
      String dateOfJoin,
      String phone,
      String email,
      String houseNo,
      String streetName,
      String city,
      String postalCode,
      String district,
      String division,
      String nid,
      String deptName,
      String salary) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/employees'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'emp_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'date_of_join': dateOfJoin,
        'phone': phone,
        'email': email,
        'house_no': houseNo,
        'street_name': streetName,
        'city': city,
        'postal_code': postalCode,
        'district': district,
        'division': division,
        'NID': nid,
        'dept_name': deptName,
        'salary': salary,
      }),
    );

    if (response.statusCode == 201) {
      print('Employee added successfully');
      fetchEmployees(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to add employee');
    }
  }


  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/employees/$id'), // Use URL params
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Employee deleted successfully');
      fetchEmployees(); // Refresh data
      _clearFields(); // Clear the form fields after submit
    } else {
      print('Failed to delete employee. Status Code: ${response.statusCode}');
    }
  }

  Future<void> updateAllEmployeesSalary(String serviceLength, String percentageIncrease) async {
    print("hello");

    // Make sure serviceLength and percentageIncrease are not empty
    if (serviceLength.isEmpty || percentageIncrease.isEmpty) {
      print("Service Length or Percentage Increase is missing.");
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/employees'), // Make sure this matches your backend
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_length': serviceLength,
          'percentage_increase': percentageIncrease,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Employees salary updated successfully');
        fetchEmployees(); // You might want to re-fetch employee data after update
        _clearFields(); // Clear fields after successful update
      } else {
        print('Failed to update employee salaries');
        print('Error details: ${response.body}');
      }
    } catch (e) {
      print('Error updating salaries: $e');
    }
  }




  // Function to clear form fields
  void _clearFields() {
    setState(() {
      empId = null;
      firstName = null;
      lastName = null;
      gender = null;
      dateOfBirth = null;
      dateOfJoin = null;
      phone = null;
      email = null;
      houseNo = null;
      streetName = null;
      city = null;
      postalCode = null;
      district = null;
      division = null;
      nid = null;
      deptName = null;
      salary = null;
    });
  }

  // Handle action based on selected radio button
  void handleAction() {
    if (selectedAction == "Add") {
      if (empId != null &&
          firstName != null &&
          lastName != null &&
          gender != null &&
          dateOfBirth != null &&
          dateOfJoin != null &&
          phone != null &&
          email != null &&
          //houseNo != null &&
          //streetName != null &&
          //city != null &&
          postalCode != null &&
          district != null &&
          division != null &&
          nid != null &&
          deptName != null &&
          salary != null) {
        addEmployee(
            empId!,
            firstName!,
            lastName!,
            gender!,
            dateOfBirth!,
            dateOfJoin!,
            phone!,
            email!,
            houseNo!,
            streetName!,
            city!,
            postalCode!,
            district!,
            division!,
            nid!,
            deptName!,
            salary!);
      } else {
        print("Please provide valid inputs for Add");
      }
    } else if (selectedAction == "Delete") {
      if (empId != null) {
        deleteEmployee(empId!);
      } else {
        print("Please provide a valid Employee ID for Delete");
      }
    }
    else if (selectedAction == "Update") {
      if (empId != null && serviceLength != null && percentageIncrease != null) {
        updateAllEmployeesSalary( serviceLength!, percentageIncrease!);
      } else {
        print("Please provide valid inputs for Update");
      }
    }

  }

  // Reset fields when switching actions
  void _resetFields() {
    setState(() {
      empId = null;
      firstName = null;
      lastName = null;
      gender = null;
      dateOfBirth = null;
      dateOfJoin = null;
      phone = null;
      email = null;
      houseNo = null;
      streetName = null;
      city = null;
      postalCode = null;
      district = null;
      division = null;
      nid = null;
      deptName = null;
      salary = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio buttons for selecting actions
            Row(
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
              ],
            ),


            if (selectedAction == "Delete") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Employee ID",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  empId = value;
                },
                controller: TextEditingController(text: empId),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Submit"),
              ),
            ],

            if (selectedAction == "Update") ...[
              TextField(
                decoration: InputDecoration(
                  labelText: "Minimum Service Length (Years)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  serviceLength = value;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Salary Increase Percentage",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  percentageIncrease = value;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (serviceLength != null && percentageIncrease != null) {
                    updateAllEmployeesSalary(serviceLength!, percentageIncrease!);
                  }
                },
                child: Text("Update Salaries"),
              ),
            ],

            // Form for Add, Delete, or Update actions

            // if (selectedAction == "Add") ...[
            //   SizedBox(height: 20),
            //   // Employee ID
            //   TextField(
            //     decoration: InputDecoration(
            //       labelText: "Employee ID",
            //     ),
            //     onChanged: (value) {
            //       empId = value;
            //     },
            //   ),
            //   SizedBox(height: 20),
            //
            //   // First Name and Last Name
            //   Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "First Name",
            //           ),
            //           onChanged: (value) {
            //             firstName = value;
            //           },
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Last Name",
            //           ),
            //           onChanged: (value) {
            //             lastName = value;
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            //   SizedBox(height: 20),
            //
            //   // Gender
            //   // Gender
            //   DropdownButton<String>(
            //     value: gender,
            //     hint: Text('Select Gender'),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         gender = newValue!;
            //       });
            //     },
            //     items: <String>['Male', 'Female', 'Other']
            //         .map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //   ),
            //   SizedBox(height: 16),
            //
            //   // Date of Birth and Date of Join
            //   Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Date of Birth",
            //           ),
            //           onChanged: (value) {
            //             dateOfBirth = value;
            //           },
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Date of Join",
            //           ),
            //           onChanged: (value) {
            //             dateOfJoin = value;
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            //   SizedBox(height: 20),
            //
            //   // Contact Information
            //   Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Phone",
            //           ),
            //           onChanged: (value) {
            //             phone = value;
            //           },
            //         ),
            //       ),
            //       SizedBox(height: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Email",
            //           ),
            //           onChanged: (value) {
            //             email = value;
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            //
            //   SizedBox(height: 20),
            //
            //   // Address Information
            //   Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "House No",
            //           ),
            //           onChanged: (value) {
            //             houseNo = value;
            //           },
            //         ),
            //       ),
            //       SizedBox(height: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "Street Name",
            //           ),
            //           onChanged: (value) {
            //             streetName = value;
            //           },
            //         ),
            //       ),
            //       SizedBox(height: 10),
            //       Expanded(
            //         child: TextField(
            //           decoration: InputDecoration(
            //             labelText: "City",
            //           ),
            //           onChanged: (value) {
            //             city = value;
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            //
            //   SizedBox(height: 10),
            //   Row(
            //       children: [
            //     Expanded(
            //       child:
            //         TextField(
            //           decoration: InputDecoration(
            //             labelText: "Postal Code",
            //           ),
            //           onChanged: (value) {
            //             postalCode = value;
            //           },
            //         ),
            //
            //     ),
            //     SizedBox(height: 10),
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           labelText: "District",
            //         ),
            //         onChanged: (value) {
            //           district = value;
            //         },
            //       ),
            //     ),
            //     SizedBox(height: 10),
            //     Expanded(
            //       child:
            //         TextField(
            //           decoration: InputDecoration(
            //             labelText: "Division",
            //           ),
            //           onChanged: (value) {
            //             division = value;
            //           },
            //         ),
            //
            //     ),
            //   ]),
            //
            //   SizedBox(height: 20),
            //
            //   // Other Information
            //   TextField(
            //     decoration: InputDecoration(
            //       labelText: "NID",
            //     ),
            //     onChanged: (value) {
            //       nid = value;
            //     },
            //   ),
            //   SizedBox(height: 10),
            //   TextField(
            //     decoration: InputDecoration(
            //       labelText: "Department Name",
            //     ),
            //     onChanged: (value) {
            //       deptName = value;
            //     },
            //   ),
            //   SizedBox(height: 10),
            //   TextField(
            //     decoration: InputDecoration(
            //       labelText: "Salary",
            //     ),
            //     onChanged: (value) {
            //       salary = value;
            //     },
            //   ),
            //   SizedBox(height: 20),
            //
            //   // Submit Button
            //   ElevatedButton(
            //     onPressed: handleAction,
            //     child: Text("Submit"),
            //   ),
            // ],
            if (selectedAction == "Add") ...[
              SizedBox(height: 20),
              // Form divided into 3 columns
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Employee ID",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            empId = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            firstName = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            lastName = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            dateOfBirth = value;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Gender",
                            border: OutlineInputBorder(),
                          ),
                          value: gender,
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                          items: ['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Second Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            phone = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "NID",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            nid = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Date of Join",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            dateOfJoin = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Department Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            deptName = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Salary",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            salary = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Third Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "House No",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            houseNo = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Street Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            streetName = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Postal Code",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            postalCode = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "City",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            city = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "District",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            district = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Division",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            division = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Submit"),
              ),
            ],


            if (selectedAction == "View") ...[
              SizedBox(height: 16),
              // Expanded(
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal, // For horizontal scrolling
              //     child: DataTable(
              //       columns: [
              //         DataColumn(label: Text("ID")),
              //         DataColumn(label: Text("First Name")),
              //         DataColumn(label: Text("Last Name")),
              //         DataColumn(label: Text("Gender")),
              //         DataColumn(label: Text("Date of Birth")),
              //         DataColumn(label: Text("Date of Join")),
              //         DataColumn(label: Text("Phone")),
              //         DataColumn(label: Text("Email")),
              //         DataColumn(label: Text("Department")),
              //         DataColumn(label: Text("Salary")),
              //       ],
              //       rows: employees.map((employee) {
              //         return DataRow(
              //           cells: [
              //             DataCell(Text(employee['emp_id']?.toString() ?? "")),
              //             DataCell(Text(employee['first_name'] ?? "")),
              //             DataCell(Text(employee['last_name'] ?? "")),
              //             DataCell(Text(employee['gender'] ?? "")),
              //             DataCell(Text(employee['date_of_birth'] ?? "")),
              //             DataCell(Text(employee['date_of_join'] ?? "")),
              //             DataCell(Text(employee['phone'] ?? "")),
              //             DataCell(Text(employee['email'] ?? "")),
              //             DataCell(Text(employee['dept_name'] ?? "")),
              //             DataCell(Text(employee['salary']?.toString() ?? "")),
              //           ],
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Enable vertical scrolling
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("First Name")),
                        DataColumn(label: Text("Last Name")),
                        DataColumn(label: Text("Gender")),
                        DataColumn(label: Text("Date of Birth")),
                        DataColumn(label: Text("Date of Join")),
                        DataColumn(label: Text("Phone")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Department")),
                        DataColumn(label: Text("Salary")),
                      ],
                      rows: employees.map((employee) {
                        return DataRow(
                          cells: [
                            DataCell(Text(employee['emp_id']?.toString() ?? "")),
                            DataCell(Text(employee['first_name'] ?? "")),
                            DataCell(Text(employee['last_name'] ?? "")),
                            DataCell(Text(employee['gender'] ?? "")),
                            DataCell(Text(employee['date_of_birth'] ?? "")),
                            DataCell(Text(employee['date_of_join'] ?? "")),
                            DataCell(Text(employee['phone'] ?? "")),
                            DataCell(Text(employee['email'] ?? "")),
                            DataCell(Text(employee['dept_name'] ?? "")),
                            DataCell(Text(employee['salary']?.toString() ?? "")),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
