import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HotelHomePage extends StatefulWidget {
  @override
  _HotelHomePageState createState() => _HotelHomePageState();
}

class _HotelHomePageState extends State<HotelHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _roomsSectionKey = GlobalKey();
  final GlobalKey _contactSectionKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  void _scrollToRooms() {
    Scrollable.ensureVisible(
      _roomsSectionKey.currentContext!,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToContactUs() {
    Scrollable.ensureVisible(
      _contactSectionKey.currentContext!,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

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
          title: Text('Welcome Admin',style: TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            color: Colors.blue[900]!,         // Sets the text color to black
          ),),
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
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Cancel'),
            // ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                side: BorderSide(
                  color: Colors.red, // Red border for Cancel
                  width: 2.0, // Border width
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.red, // Red font for Cancel
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;

                // API URL for login validation
                final url = Uri.parse(
                    'http://localhost:3000/login'); // Adjust if your backend is running on a different host

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
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                side: BorderSide(
                  color: Colors.blue[900]!, // Dark blue border for Confirm
                  width: 2.0, // Border width
                ),
              ),
              child: Text('Submit',style: TextStyle(
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.blue[900]!, // Blue font for Confirm
              ),),
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
    final checkInDateController1 = TextEditingController();
    final checkOutDateController1 = TextEditingController();
    final checkInDateController2 = TextEditingController();
    final checkOutDateController2 = TextEditingController();
    final checkInDateController3 = TextEditingController();
    final checkOutDateController3 = TextEditingController();
    String? gender;
    String? roomType1;
    String? roomType2;
    String? roomType3;

    // double totalBill1 = 10.0;
    //double totalBill2 = 10.0;
    //double totalBill3 = 10.0;

    String? paymentMethod;

    void _showPaymentPopup(double totalBill) {
      final TextEditingController paidAmountController =
          TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // Reduced width
              constraints: BoxConstraints(maxHeight: 300), // Reduced height
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Payment Confirmation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,// Makes the text bold
                      color: Colors.blue[900]!,         // Sets the text color to black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Bill: \$${totalBill.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Minimum Payment Required: \$${(totalBill * 0.5).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: paidAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Paid Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 30, vertical: 15),
                      //   ),
                      //   child: Text('Cancel'),
                      // ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          side: BorderSide(
                            color: Colors.red, // Red border for Cancel
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Bold text
                            color: Colors.red, // Red font for Cancel
                          ),
                        ),
                      ),
                      SizedBox(width: 20),

                      ElevatedButton(
                        onPressed: () async {
                          double paidAmount =
                              double.tryParse(paidAmountController.text) ?? 0;

                          if (paidAmount < totalBill * 0.5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Paid amount must be at least 50% of the total bill!'),
                              ),
                            );
                          } else {
                            try {
                              final paymentUrl =
                                  Uri.parse('http://localhost:3000/addPayment');
                              final paymentRequestBody = {
                                'total_amount': totalBill,
                                'paid': paidAmount,
                              };

                              final response = await http.post(
                                paymentUrl,
                                headers: {'Content-Type': 'application/json'},
                                body: json.encode(paymentRequestBody),
                              );

                              if (response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Payment successful!')),
                                );
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              } else {
                                final responseData = json.decode(response.body);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(responseData['message'] ??
                                          'Failed to process payment.')),
                                );
                              }
                            } catch (e) {
                              print('Error: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'An error occurred while processing the payment.')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          side: BorderSide(
                            color: Colors.blue[900]!, // Dark blue border for Confirm
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Text('Submit', style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.blue[900]!, // Blue font for Confirm
                        ),),
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

    void _submitForm() async {
      final combinedUrl =
          Uri.parse('http://localhost:3000/addCustomerAndReservation');

      final reservations = [];

      // Add reservation for room 1 if valid
      if (roomType1 != null &&
          checkInDateController1.text.isNotEmpty &&
          checkOutDateController1.text.isNotEmpty) {
        reservations.add({
          'room_type': roomType1,
          'check_in_date': checkInDateController1.text,
          'check_out_date': checkOutDateController1.text,
          //  'total_bill': totalBill1,
        });
      }

      // Add reservation for room 2 if valid
      if (roomType2 != null &&
          checkInDateController2.text.isNotEmpty &&
          checkOutDateController2.text.isNotEmpty) {
        reservations.add({
          'room_type': roomType2,
          'check_in_date': checkInDateController2.text,
          'check_out_date': checkOutDateController2.text,
          // 'total_bill': totalBill2,
        });
      }

      // Add reservation for room 3 if valid
      if (roomType3 != null &&
          checkInDateController3.text.isNotEmpty &&
          checkOutDateController3.text.isNotEmpty) {
        reservations.add({
          'room_type': roomType3,
          'check_in_date': checkInDateController3.text,
          'check_out_date': checkOutDateController3.text,
          // 'total_bill': totalBill3,
        });
      }
      print(reservations);

      if (reservations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please provide at least one valid reservation.')),
        );
        return;
      }

      // Prepare the request payload
      final requestBody = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': gender,
        'email': emailController.text,
        'phone': phoneController.text,
        'rating': 0,
        'reservations': reservations,
      };

      try {
        final response = await http.post(
          combinedUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        );

        if (response.statusCode == 201) {
          //  ScaffoldMessenger.of(context).showSnackBar(
          //    SnackBar(content: Text('Reservations created successfully!')),
          // );
          // Calculate the total bill and show the payment popup
          // if (response.statusCode == 201) {
          final responseData = json.decode(response.body);
          final totalBill = responseData['pay'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservations created successfully!')),
          );

          // Show payment popup
          _showPaymentPopup(totalBill);
          // }
        } else {
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(responseData['message'] ??
                    'Failed to create reservations.')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('An error occurred while creating the reservations.')),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Makes the text bold
                    color: Colors.blue[900]!,         // Sets the text color to black
                    fontSize: 24,
                  ),
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
                          SizedBox(
                            height: 10,
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
                              labelText: 'Room Type for 1',
                              border: OutlineInputBorder(),
                            ),
                            value: roomType1,
                            items: ['Single Bed', 'Double Bed']
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              roomType1 = value;
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkInDateController1,
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
                                checkInDateController1.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkOutDateController1,
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
                                checkOutDateController1.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                              labelText: 'Room Type for 2',
                              border: OutlineInputBorder(),
                            ),
                            value: roomType2,
                            items: ['Single Bed', 'Double Bed']
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              roomType2 = value;
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkInDateController2,
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
                                checkInDateController2.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkOutDateController2,
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
                                checkOutDateController2.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                              labelText: 'Room Type for 3',
                              border: OutlineInputBorder(),
                            ),
                            value: roomType3,
                            items: ['Single Bed', 'Double Bed']
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              roomType3 = value;
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkInDateController3,
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
                                checkInDateController3.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: checkOutDateController3,
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
                                checkOutDateController3.text = selectedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    //   ),
                    //   child: Text('Cancel'),
                    // ),
                    // SizedBox(width: 20),
                    // ElevatedButton(
                    //   onPressed: _submitForm,
                    //   style: ElevatedButton.styleFrom(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    //   ),
                    //   child: Text('Confirm'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        side: BorderSide(
                          color: Colors.red, // Red border for Cancel
                          width: 2.0, // Border width
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.red, // Red font for Cancel
                        ),
                      ),
                    ),

                    SizedBox(width: 20),

                    ElevatedButton(
                      onPressed: _submitForm,
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



  void _sendFeedback() {
    // Here, you can handle feedback submission
    String email = _emailController.text;
    String feedback = _feedbackController.text;

    // Handle the feedback, for example, by sending it to a backend or displaying a success message
    print("Email: $email");
    print("Feedback: $feedback");

    // Clear the fields after submission
    _emailController.clear();
    _feedbackController.clear();

    // Optionally, show a confirmation dialog or message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Feedback Sent'),
        content: Text('Thank you for your feedback!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
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
                  'Royal Haven Hotel',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                   // Makes the text bold
                      color: Colors.blue[900]!,         // Sets the text color to black

                  ),
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {}, child: Text('Home',style: TextStyle(
                     // fontWeight: FontWeight.bold, // Makes the text bold
                      color: Colors.blue[900]!,         // Sets the text color to black
                    ),)),
                    TextButton(onPressed: _scrollToRooms, child: Text('Rooms',style: TextStyle(
                     // fontWeight: FontWeight.bold, // Makes the text bold
                      color: Colors.blue[900]!,         // Sets the text color to black
                    ),)),
                    //   TextButton(onPressed: () {}, child: Text('Facilities')),
                    TextButton(onPressed: () {}, child: Text('Contact Us',style: TextStyle(
                    //  fontWeight: FontWeight.bold, // Makes the text bold
                      color: Colors.blue[900]!,         // Sets the text color to black
                    ),)),
                    // TextButton(onPressed: () {}, child: Text('About')),
                    SizedBox(width: 20),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _showBookingPopup(context);
                    //   },
                    //   child: Text('Book Now'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _showBookingPopup(context);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.zero,
                    //     ),
                    //   ),
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
                        side: BorderSide(
                          color: Colors.blue[900]!,  // Dark blue color
                          width: 2.0,  // Border width
                        ),
                      ),
                      child: Text('Book Now',style: TextStyle(
                        fontWeight: FontWeight.bold, // Makes the text bold
                        color: Colors.blue[900]!,         // Sets the text color to black
                      ),),
                    ),

                    SizedBox(width: 10),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _showLoginPopup(context);
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.zero,
                    //     ),
                    //   ),
                    //   child: Text('Login'),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        _showLoginPopup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        side: BorderSide(
                          color: Colors.blue[900]!,  // Dark blue color
                          width: 2.0,  // Border width
                        ),
                      ),
                      child: Text('Login',style: TextStyle(
                        fontWeight: FontWeight.bold, // Makes the text bold
                        color: Colors.blue[900]!,         // Sets the text color to black
                      ),),
                    )

                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 50),

          // Rooms Section
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Background Image
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/h1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Rooms Section
                  Container(
                    key: _roomsSectionKey, // Assigning key to Rooms section
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rooms',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            return RoomCard(room: rooms[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Contact Us Section
                  Container(
                    key: _contactSectionKey, // Assigning key to Contact section
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Us',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        // Social Media and Feedback
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.facebook,
                                  size: 40, color: Colors.blue),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.email,
                                  size: 40, color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Implement send feedback functionality here
                            //_showFeedbackPopup(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text('Send Feedback'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ]));
  }

}

// Room Model
class Room {
  final String name;
  final String image;
  final String price;
  final String details;

  Room(
      {required this.name,
      required this.image,
      required this.price,
      required this.details});
}

// Sample Room Data
List<Room> rooms = [
  Room(
      name: "Single Bed Room",
      image: "assets/room1.jpg",
      price: "\2100 BDT/night",
      details: "Cozy room with single bed, WiFi, and AC."),
  Room(
      name: "Single Bed Room",
      image: "assets/room2.jpg",
      price: "\2100 BDT/night",
      details: "Cozy room with single bed, WiFi, and AC."),
  Room(
      name: "Single Bed Room",
      image: "assets/room3.jpg",
      price: "\2100 BDT/night",
      details: "Cozy room with single bed, WiFi, and AC."),
  Room(
      name: "Double Bed Room",
      image: "assets/room4.jpg",
      price: "\4000 BDT/night",
      details: "Spacious double bed room with a great view."),
  Room(
      name: "Double Bed Room",
      image: "assets/room5.jpg",
      price: "\4000 BDT/night",
      details: "Spacious double bed room with a great view."),
];

// Room Card Widget
class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(room.image,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(room.details,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 5),
                Text(room.price,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Popups (To be implemented)
void _showBookingPopup(BuildContext context) {
  // Show Booking Popup
}

void _showLoginPopup(BuildContext context) {
  // Show Login Popup
}
