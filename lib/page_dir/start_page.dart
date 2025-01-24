// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'book_now.dart';
//
// class HotelWebPage extends StatelessWidget {
//
//   // void _showLoginPopup(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(20.0),
//   //         ),
//   //         title: Text('Welcome Admin'),
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             TextField(
//   //               decoration: InputDecoration(
//   //                 labelText: 'Username',
//   //                 border: OutlineInputBorder(),
//   //               ),
//   //             ),
//   //             SizedBox(height: 10),
//   //             TextField(
//   //               obscureText: true,
//   //               decoration: InputDecoration(
//   //                 labelText: 'Password',
//   //                 border: OutlineInputBorder(),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Cancel'),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               // Add login logic here
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text('Submit'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
//
//
//
//   void _showBookingPopup(BuildContext context) {
//     final firstNameController = TextEditingController();
//     final lastNameController = TextEditingController();
//     final emailController = TextEditingController();
//     final phoneController = TextEditingController();
//     DateTime? checkInDate;
//     DateTime? checkOutDate;
//     String? gender;
//     String? roomType;
//     double totalBill = 0.0;
//
//     void _showLoginPopup(BuildContext context) {
//       final usernameController = TextEditingController();
//       final passwordController = TextEditingController();
//
//       void _submitForm() async {
//         final url = Uri.parse('http://localhost:3000/addCustomer');
//
//         final response = await http.post(
//           url,
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({
//             'first_name': firstNameController.text,
//             'last_name': lastNameController.text,
//             'gender': gender,
//             'email': emailController.text,
//             'phone': phoneController.text,
//             'rating': 0, // Default rating
//             'room_id': selectedRoomId, // Pass the selected room ID
//             'check_in_date': checkInDate?.toIso8601String(),
//             'check_out_date': checkOutDate?.toIso8601String(),
//             'total_bill': totalBill,
//           }),
//         );
//
//         if (response.statusCode == 201) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Customer and reservation added successfully!')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to add customer and reservation.')),
//           );
//         }
//       }
//
//
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             title: Text('Welcome Admin'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Username',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final username = usernameController.text;
//                   final password = passwordController.text;
//
//                   // API URL for login validation
//                   final url = Uri.parse('http://localhost:3000/login'); // Adjust if your backend is running on a different host
//
//                   // Send the POST request to validate login credentials
//                   final response = await http.post(
//                     url,
//                     headers: {'Content-Type': 'application/json'},
//                     body: json.encode({
//                       'username': username,
//                       'password': password,
//                     }),
//                   );
//
//                   if (response.statusCode == 200) {
//                     // Navigate to the adminsection page on successful login
//                     Navigator.of(context).pop(); // Close the login dialog
//                     Navigator.pushReplacementNamed(context, '/adminsection');
//                   } else {
//                     // Show an error if credentials are invalid
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Invalid credentials')),
//                     );
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.7, // 70% of screen width
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Welcome to our hotel',
//                   style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextField(
//                             controller: firstNameController,
//                             decoration: InputDecoration(
//                               labelText: 'First Name',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           TextField(
//                             controller: emailController,
//                             decoration: InputDecoration(
//                               labelText: 'Email',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: 'Gender',
//                               border: OutlineInputBorder(),
//                             ),
//                             value: gender,
//                             items: ['Male', 'Female']
//                                 .map((gender) => DropdownMenuItem(
//                               value: gender,
//                               child: Text(gender),
//                             ))
//                                 .toList(),
//                             onChanged: (value) {
//                               gender = value;
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           TextField(
//                             controller: phoneController,
//                             decoration: InputDecoration(
//                               labelText: 'Phone',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextField(
//                             controller: lastNameController,
//                             decoration: InputDecoration(
//                               labelText: 'Last Name',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: 'Room Type',
//                               border: OutlineInputBorder(),
//                             ),
//                             value: roomType,
//                             items: ['Single Bed', 'Double Bed']
//                                 .map((room) => DropdownMenuItem(
//                               value: room,
//                               child: Text(room),
//                             ))
//                                 .toList(),
//                             onChanged: (value) {
//                               roomType = value;
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           TextField(
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               labelText: 'Check-in Date',
//                               border: OutlineInputBorder(),
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                             onTap: () async {
//                               checkInDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2100),
//                               );
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           TextField(
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               labelText: 'Check-out Date',
//                               border: OutlineInputBorder(),
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                             onTap: () async {
//                               checkOutDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: checkInDate ?? DateTime.now(),
//                                 firstDate: checkInDate ?? DateTime.now(),
//                                 lastDate: DateTime(2100),
//                               );
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Total Bill: \$${totalBill.toStringAsFixed(2)}',
//                             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Confirm action (example logic, modify as needed)
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Booking confirmed successfully!')),
//                         );
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                       ),
//                       child: Text('Cancel'),
//                     ),
//                     SizedBox(width: 20), // Space between buttons
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                       ),
//                       child: Text('Confirm'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/h1.jpg'), // Replace with your image
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               // Navigation Bar
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20.0),
//                 color: Colors.white.withOpacity(0.9),
//                 height: 80.0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'HB Website',
//                       style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         TextButton(
//                           onPressed: () {},
//                           child: Text('Home'),
//                         ),
//                         SizedBox(width: 10),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text('Rooms'),
//                         ),
//                         SizedBox(width: 10),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text('Facilities'),
//                         ),
//                         SizedBox(width: 10),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text('Contact Us'),
//                         ),
//                         SizedBox(width: 10),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text('About'),
//                         ),
//                         SizedBox(width: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             _showBookingPopup(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.zero,
//                             ),
//                           ),
//                           child: Text('Book Now'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             _showLoginPopup(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.zero,
//                             ),
//                           ),
//                           child: Text('Login'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Spacer
//               Spacer(),
//
//               // Search Card
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
//                 padding: EdgeInsets.all(20.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(15.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10.0,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Check Booking Availability',
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 20.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Check-in',
//                               border: OutlineInputBorder(),
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.0),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Check-out',
//                               border: OutlineInputBorder(),
//                               suffixIcon: Icon(Icons.calendar_today),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Adult',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.0),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               labelText: 'Children',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20.0),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 40.0,
//                           vertical: 15.0,
//                         ),
//                       ),
//                       child: Text(
//                         'Submit',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelWebPage extends StatelessWidget {
  // void _showBookingPopup(BuildContext context) {
  //   final firstNameController = TextEditingController();
  //   final lastNameController = TextEditingController();
  //   final emailController = TextEditingController();
  //   final phoneController = TextEditingController();
  //   DateTime? checkInDate;
  //   DateTime? checkOutDate;
  //   String? gender;
  //   String? roomType;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20.0),
  //         ),
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.7,
  //           padding: EdgeInsets.all(20.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Welcome to our hotel',
  //                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         TextField(
  //                           controller: firstNameController,
  //                           decoration: InputDecoration(
  //                             labelText: 'First Name',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         SizedBox(height: 10),
  //                         TextField(
  //                           controller: emailController,
  //                           decoration: InputDecoration(
  //                             labelText: 'Email',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         SizedBox(height: 10),
  //                         DropdownButtonFormField<String>(
  //                           decoration: InputDecoration(
  //                             labelText: 'Gender',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                           value: gender,
  //                           items: ['Male', 'Female']
  //                               .map((item) => DropdownMenuItem(
  //                             value: item,
  //                             child: Text(item),
  //                           ))
  //                               .toList(),
  //                           onChanged: (value) {
  //                             gender = value;
  //                           },
  //                         ),
  //                         SizedBox(height: 10),
  //                         TextField(
  //                           controller: phoneController,
  //                           decoration: InputDecoration(
  //                             labelText: 'Phone',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(width: 20),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         TextField(
  //                           controller: lastNameController,
  //                           decoration: InputDecoration(
  //                             labelText: 'Last Name',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                         ),
  //                         SizedBox(height: 10),
  //                         DropdownButtonFormField<String>(
  //                           decoration: InputDecoration(
  //                             labelText: 'Room Type',
  //                             border: OutlineInputBorder(),
  //                           ),
  //                           value: roomType,
  //                           items: ['Single Bed', 'Double Bed']
  //                               .map((item) => DropdownMenuItem(
  //                             value: item,
  //                             child: Text(item),
  //                           ))
  //                               .toList(),
  //                           onChanged: (value) {
  //                             roomType = value;
  //                           },
  //                         ),
  //                         SizedBox(height: 10),
  //                         TextField(
  //                           readOnly: true,
  //                           decoration: InputDecoration(
  //                             labelText: 'Check-in Date',
  //                             border: OutlineInputBorder(),
  //                             suffixIcon: Icon(Icons.calendar_today),
  //                           ),
  //                           onTap: () async {
  //                             checkInDate = await showDatePicker(
  //                               context: context,
  //                               initialDate: DateTime.now(),
  //                               firstDate: DateTime.now(),
  //                               lastDate: DateTime(2100),
  //                             );
  //                           },
  //                         ),
  //                         SizedBox(height: 10),
  //                         TextField(
  //                           readOnly: true,
  //                           decoration: InputDecoration(
  //                             labelText: 'Check-out Date',
  //                             border: OutlineInputBorder(),
  //                             suffixIcon: Icon(Icons.calendar_today),
  //                           ),
  //                           onTap: () async {
  //                             checkOutDate = await showDatePicker(
  //                               context: context,
  //                               initialDate: checkInDate ?? DateTime.now(),
  //                               firstDate: checkInDate ?? DateTime.now(),
  //                               lastDate: DateTime(2100),
  //                             );
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //                     ),
  //                     child: Text('Cancel'),
  //                   ),
  //                   SizedBox(width: 20),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(content: Text('Booking confirmed!')),
  //                       );
  //                       Navigator.of(context).pop();
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  //                     ),
  //                     child: Text('Confirm'),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //

  void _showLoginPopup(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

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
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
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
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;

                // API URL for login validation
                final url = Uri.parse('http://localhost:3000/login'); // Adjust if your backend is running on a different host

                // Send the POST request to validate login credentials
                final response = await http.post(
                  url,
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'username': username,
                    'password': password,
                  }),
                );

                if (response.statusCode == 200) {
                  // Navigate to the adminsection page on successful login
                  Navigator.of(context).pop(); // Close the login dialog
                  Navigator.pushReplacementNamed(context, '/adminsection');
                } else {
                  // Show an error if credentials are invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid credentials')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }



  void _showBookingPopup(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final checkInDateController = TextEditingController();
    final checkOutDateController = TextEditingController();
    String? gender;
    String? roomType;
    double totalBill = 10.0;
    String?paymentMethod;

    // Add the _submitForm function inside to access the variables
    // void _submitForm() async {
    //   final customerUrl = Uri.parse('http://localhost:3000/addCustomer');
    //   final reservationUrl = Uri.parse('http://localhost:3000/addReservation');
    //
    //   final customerResponse = await http.post(
    //     customerUrl,
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode({
    //       'first_name': firstNameController.text,
    //       'last_name': lastNameController.text,
    //       'gender': gender,
    //       'email': emailController.text,
    //       'phone': phoneController.text,
    //       'rating': 0,
    //     }),
    //   );
    //
    //   if (customerResponse.statusCode == 201) {
    //     final customerData = json.decode(customerResponse.body);
    //     final cusId = customerData['cus_id'];
    //
    //     // Pass cusId to reservation API
    //     final reservationResponse = await http.post(
    //       reservationUrl,
    //       headers: {'Content-Type': 'application/json'},
    //       body: json.encode({
    //         'cus_id': cusId,
    //         'room_type': roomType,
    //         'check_in_date': checkInDateController.text,
    //         'check_out_date': checkOutDateController.text,
    //         'total_bill': totalBill,
    //       }),
    //     );
    //
    //     if (reservationResponse.statusCode == 201) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Reservation created successfully!')),
    //       );
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Failed to create reservation.')),
    //       );
    //     }
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to add customer.')),
    //     );
    //   }
    //
    // }

    void _submitForm() async {
      final combinedUrl = Uri.parse('http://localhost:3000/addCustomerAndReservation');

      // Prepare the request payload
      final requestBody = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': gender,
        'email': emailController.text,
        'phone': phoneController.text,
        'rating': 0,
        'room_type': roomType,
        'check_in_date': checkInDateController.text,
        'check_out_date': checkOutDateController.text,
        'total_bill': totalBill,
      };

      try {
        // Send the request to the combined API
        final response = await http.post(
          combinedUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservation created successfully!')),
          );
        } else if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Customer already exists. Reservation created successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create reservation.')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while creating the reservation.')),
        );
      }
    }


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to our hotel',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                            ),
                            value: gender,
                            items: ['Male', 'Female']
                                .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            onChanged: (value) {
                              gender = value;
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextField(
                          //   controller: lastNameController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Last Name',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          // SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Room Type',
                              border: OutlineInputBorder(),
                            ),
                            value: roomType,
                            items: ['Single Bed', 'Double Bed']
                                .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            onChanged: (value) {
                              roomType = value;
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkInDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Check-in Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                checkInDateController.text =
                                    selectedDate.toIso8601String().split('T').first;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkOutDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Check-out Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                checkOutDateController.text =
                                    selectedDate.toIso8601String().split('T').first;
                              }
                            },
                          ),
                          SizedBox(height: 10,),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Payment Method',
                              border: OutlineInputBorder(),
                            ),
                            value: paymentMethod,
                            items: ['Cash', 'Banking/Others']
                                .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            onChanged: (value) {
                              paymentMethod = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                image: AssetImage('assets/h1.jpg'),
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
                        TextButton(onPressed: () {}, child: Text('Home')),
                        TextButton(onPressed: () {}, child: Text('Rooms')),
                        TextButton(onPressed: () {}, child: Text('Facilities')),
                        TextButton(onPressed: () {}, child: Text('Contact Us')),
                        TextButton(onPressed: () {}, child: Text('About')),
                        SizedBox(width: 20),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     _showBookingPopup(context);
                        //   },
                        //   child: Text('Book Now'),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            _showBookingPopup(context);
                          },
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
              Spacer(),
              // Booking Availability Section
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
                  children: [
                    Text(
                      'Check Booking Availability',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                      child: Text('Submit'),
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