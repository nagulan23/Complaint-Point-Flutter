import 'package:complaint_point/home_page.dart';
import 'package:complaint_point/post.dart';
import 'package:complaint_point/root.dart';
import 'package:flutter/material.dart';
import 'login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complaint Point',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: RootPage(),
    );
  }
}


