import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<dynamic> payments = [];
  String selectedAction = "View"; // Default action is "View"
  String? paymentId;
  String? customerId;
  String? totalAmount;
  String? paidAmount;
  String? dueAmount;

  @override
  void initState() {
    super.initState();
    fetchPayments(); // Fetch data on load
  }

  // Fetch all payments
  Future<void> fetchPayments() async {
    final response = await http.get(Uri.parse('http://localhost:3000/payment'));
    if (response.statusCode == 200) {
      setState(() {
        payments = json.decode(response.body);
      });
    } else {
      print('Failed to fetch payments');
    }
  }

  // Update payment
  // Future<void> updatePayment(int id, double totalAmount, double paid) async {
  //   final response = await http.put(
  //     Uri.parse('http://localhost:3000/payment/$id'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'total_amount': totalAmount,
  //       'paid': paid,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Payment updated successfully');
  //   } else {
  //     print('Failed to update payment: ${response.body}');
  //   }
  // }
  Future<void> updatePayment(int id, String totalAmountString, String paidAmountString) async {
    // Convert total_amount and paid to appropriate types
    double totalAmount = double.parse(totalAmountString);
    double paid = double.parse(paidAmountString);

    final response = await http.put(
      Uri.parse('http://localhost:3000/payment/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'total_amount': totalAmount,
        'paid': paid,
      }),
    );

    if (response.statusCode == 200) {
      print('Payment updated successfully');
    } else {
      print('Failed to update payment: ${response.body}');
    }
  }


  // Handle action based on selected radio button
  void handleAction() {
    if (selectedAction == "Update") {
      if (paymentId != null && paidAmount != null && dueAmount != null) {
        _showConfirmationDialog(
          "Update Payment",
          "Are you sure you want to update the payment?",
              () => updatePayment(paymentId! as int, paidAmount! , dueAmount! ),
        );
      } else {
        print("Please provide valid inputs for Update");
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
      paymentId = null;
      customerId = null;
      totalAmount = null;
      paidAmount = null;
      dueAmount = null;
    });
  }

  // Reset fields when switching actions
  void _resetFields() {
    setState(() {
      paymentId = null;
      customerId = null;
      totalAmount = null;
      paidAmount = null;
      dueAmount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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

            // Form for Update action
            if (selectedAction == "Update") ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Payment ID",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  paymentId = value;
                },
                controller: TextEditingController(text: paymentId),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Paid Amount",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  paidAmount = value;
                },
                controller: TextEditingController(text: paidAmount),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "Due Amount",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                onChanged: (value) {
                  dueAmount = value;
                },
                controller: TextEditingController(text: dueAmount),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleAction,
                child: Text("Submit"),
              ),
            ],

            // Table-like structure for payment information
            if (selectedAction == "View") ...[
              SizedBox(height: 20),
              DataTable(
                columns: [
                  DataColumn(label: Text("Payment ID")),
                  DataColumn(label: Text("Customer ID")),
                  DataColumn(label: Text("Total Amount")),
                  DataColumn(label: Text("Paid")),
                  DataColumn(label: Text("Due")),
                ],
                rows: payments
                    .map<DataRow>((payment) => DataRow(cells: [
                  DataCell(Text(payment['id'].toString())),
                  DataCell(Text(payment['cus_id'].toString())),
                  DataCell(Text(payment['total_amount'].toString())),
                  DataCell(Text(payment['paid'].toString())),
                  DataCell(Text(payment['due'].toString())),
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
