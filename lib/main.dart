import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:tbd/login_page.dart';
import 'package:tbd/models/theme_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int themeType = sharedPreferences.getInt("themeType") ?? 0;
  runApp(MyApp(themeType: themeType));
}

class MyApp extends StatelessWidget {
  final int themeType;
  const MyApp({super.key, required this.themeType});

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
        final settings = ThemeSettings(themeType);
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'StudentNote',
            theme: settings.currentTheme,
            home: LoginPage(title: "page"),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: Text("Loading", textDirection: TextDirection.ltr));
      },
    );
  }
}
