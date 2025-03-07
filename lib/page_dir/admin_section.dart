
import 'package:flutter/material.dart';
import 'package:hotel_dbms/page_dir/DeptAvgSalary.dart';
import 'package:hotel_dbms/page_dir/DeptSortByBudget.dart';
import 'package:hotel_dbms/page_dir/DirtyRooms.dart';
import 'package:hotel_dbms/page_dir/EmployeeMinusGuard.dart';
import 'package:hotel_dbms/page_dir/employee.dart';
import 'package:hotel_dbms/page_dir/payment.dart';
import 'package:hotel_dbms/page_dir/room.dart';
import 'package:hotel_dbms/page_dir/department.dart';
import 'package:hotel_dbms/page_dir/start_page.dart';

import 'AllCustomerPage.dart';
import 'EmployeeCounttByDeptPage.dart';
import 'EmployeesAbovAverage.dart';
import 'GpUser.dart';
import 'MaximumSalaryPage.dart';
import 'ProfitPerMonthPage.dart';
import 'ReservationCountEachCustomer.dart';
import 'ReservationPage.dart';
import 'current_customers.dart';
import 'ServiceLength.dart';
import 'DriverDetails.dart';
import 'AvailableRooms.dart';
import 'highBudgetEmployees.dart';


class AdminSection extends StatefulWidget {
  @override
  _AdminSection createState() => _AdminSection();
}

class _AdminSection extends State<AdminSection> {
  int _selectedIndex = 0; // Tracks the current selected menu index

  // List of pages to display in the right panel
  final List<Widget> _pages = [
    Center(child: Text('Dashboard')), // Placeholder for Dashboard
    RoomPage(),
    EmployeePage(),
    DepartmentPage(),
   // Center(child: Text('Customers')),//Placeholder for Customers
    CustomerPage(),
   // Center(child: Text('Reservations')), // Placeholder for Reservations
   // Center(child: Text('Payments')), // Placeholder for Payments
    ReservationPage(),
    PaymentPage(),
    CurrentCustomersPage(), // New "Current Customers" page
    EmployeeCountByDeptPage(), // New "Employee Count by Department" page
    ProfitPerMonthPage(), // New "Profit Per Month" page
    MaximumSalaryPage(),
    Servicelength(),
    Driverdetails(),
    Deptavgsalary(),
    Availablerooms(),
    Dirtyrooms(),
    Deptsortbybudget(),
    HighBudgetEmployees(),
    CustomerReservations(),
    EmployeesAboveAvgSalary(),
    Gpuser(),
    Employeeminusguard(),
  ];

  void _navigateToHotelHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HotelHomePage()), // Replace with your actual homepage widget
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
            child: SingleChildScrollView( // Makes the side menu scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerHeader(
                    // child: Text(
                    //   'Menu',
                    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // decoration: BoxDecoration(color: Colors.blue),
                   child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: _navigateToHotelHomePage,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Menu',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(color: Colors.blue[900]),
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.meeting_room),
                    title: Text('Rooms'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Employees'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.business),
                    title: Text('Departments'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Customers'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Reservations'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 5;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Payments'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 6;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: const Text('Current Customers'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 7;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart),
                    title: const Text('Employee Count by Dept'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 8;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pie_chart),
                    title: const Text('Profit Per Month'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 9;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: const Text('Maximum Salary'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 10;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.room_service),
                    title: const Text('Service Length of Employee'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 11;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.drive_eta),
                    title: const Text('Driver Info'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 12;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.money),
                    title: const Text('Dept Avg salary'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 13;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.event_available),
                    title: const Text('Available Room'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 14;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.dirty_lens),
                    title: const Text('Dirty Room'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 15;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.sort),
                    title: const Text('Sort Dept by Budget'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 16;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: const Text('Employees with High Budget Department'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 17;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.room),
                    title: const Text('Reservation Count per Customer'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 18;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: const Text('Employees Above Average Dept salary'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 19;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: const Text('Gp User Employee '),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 20;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: const Text('Employee Except SecurityGuard'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 21;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Main Content (Right Panel)
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

}
