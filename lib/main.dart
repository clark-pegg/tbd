import 'package:flutter/material.dart';
import 'package:tbd/login_page.dart';

import './home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBD Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: "page"),
    );
  }
}
