import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  ThemeSettings(int themeType) {
    if (themeType == 0) {
      _currentTheme = ThemeData.light();
    } else if (themeType == 1) {
      _currentTheme = ThemeData.dark();
    } else {
      _currentTheme = ThemeData.light();
    }
  }

  static void changeTheme(int themeType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (themeType == 0) {
      sharedPreferences.setInt("themeType", themeType);
    } else if (themeType == 1) {
      sharedPreferences.setInt("themeType", themeType);
    } else {
      sharedPreferences.setInt("themeType", 0);
    }
  }
}
