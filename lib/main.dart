

import 'package:flutter/material.dart';
import 'package:hotel_dbms/page_dir/admin_section.dart';
import 'package:hotel_dbms/page_dir/start_page.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Management System',
      initialRoute: '/',
      routes: {
        '/': (context) => HotelHomePage(), // Your home page widget
        '/adminsection': (context) => AdminSection(), // Admin section page
      },
    );
  }
}



