import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tbd/login_page.dart';

import './home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text("An error has occured"));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'StudentNote',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: LoginPage(title: "page"),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: Text("Loading", textDirection: TextDirection.ltr));
      },
    );
  }
}
