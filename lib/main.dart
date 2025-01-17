// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class SQLTable extends StatefulWidget {
//   @override
//   _SQLTableState createState() => _SQLTableState();
// }
//
// class _SQLTableState extends State<SQLTable> {
//   List<dynamic> _data = [];
//
//   Future<void> fetchData() async {
//     final url = Uri.parse('http://localhost:3000/query'); // Backend URL
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _data = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('SQL Query Result')),
//       body: _data.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: _data.isNotEmpty
//               ? (_data[0].keys.map<DataColumn>((key) => DataColumn(label: Text(key))).toList())
//               : [],
//           rows: _data
//               .map<DataRow>((row) => DataRow(
//             cells: row.values
//                 .map<DataCell>((value) => DataCell(Text(value.toString())))
//                 .toList(),
//           ))
//               .toList(),
//         ),
//       )
//
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(home: SQLTable()));
// }

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HotelWebPage(),
//     );
//   }
// }
//
// class HotelWebPage extends StatelessWidget {
//   void _showLoginPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           title: Text('Welcome Admin'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Add login logic here
//                 Navigator.of(context).pop();
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // Navigation Bar
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             color: Colors.blue,
//             height: 80.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.hotel,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//                 Text(
//                   'Dummy Hotel Name',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text('Book Now'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orange,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () => _showLoginPopup(context),
//                       child: Text('Login'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Hotel Image
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/h1.jpg'), // Replace with your image path
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HotelWebPage(),
    );
  }
}

class HotelWebPage extends StatelessWidget {

  void _showLoginPopup(BuildContext context) {
    showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20.0),
           ),
           title: Text('Welcome Admin'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextField(
                 decoration: InputDecoration(
                   labelText: 'Username',
                   border: OutlineInputBorder(),
                 ),
              ),
               SizedBox(height: 10),
               TextField(
                obscureText: true,
                 decoration: InputDecoration(
                   labelText: 'Password',
                   border: OutlineInputBorder(),
                 ),
              ),
            ],
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                 // Add login logic here
                 Navigator.of(context).pop();
               },
               child: Text('Submit'),
             ),
          ],
         );
      },
     );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/h1.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Navigation Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                color: Colors.white.withOpacity(0.9),
                height: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HB Website',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Home'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text('Rooms'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text('Facilities'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text('Contact Us'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text('About'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text('Book Now'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                    _showLoginPopup(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Spacer
              Spacer(),

              // Search Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Check Booking Availability',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Check-in',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Check-out',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Adult',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Children',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 15.0,
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
