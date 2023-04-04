import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tbd/models/theme_settings.dart';
import 'package:tbd/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_page.dart';

enum Themes { light, dark }

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Themes? _currentTheme = Themes.light;

  Text themeText() {
    switch (_currentTheme) {
      case Themes.light:
        return Text("Light");
      case Themes.dark:
        return Text("Dark");
      default:
        return Text("Dark");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), actions: []),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.account_circle),
                title: Text('Log out'),
                onPressed: (value) async {
                  LoginPage.googleSignIn?.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return LoginPage(title: "Login Page");
                  }), (r) {
                    return false;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Theme'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Choose theme'),
                onPressed: (value) => _themeSelection(context),
              ),
            ],
          ),
          /*SettingsSection(
            title: Text('Notifications'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Notification settings'),
                onPressed: (value) {},
              ),
            ],
          ),*/
          SettingsSection(
            title: Text('Feedback'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Report a bug'),
                onPressed: (value) => _bugDialog(context),
              ),
              SettingsTile.navigation(
                title: Text('Send feedback'),
                onPressed: (value) => _feedbackDialog(context),
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('About the app'),
                value: Text('Version 0.1'),
                onPressed: (value) => _aboutDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _themeSelection(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int themeType = sharedPreferences.getInt("themeType") ?? 0;
    if (themeType == 0) {
      _currentTheme = Themes.light;
    } else if (themeType == 1) {
      _currentTheme = Themes.dark;
    } else {
      _currentTheme = Themes.light;
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose theme'),
          actions: <Widget>[
            ListTile(
              title: const Text('Light'),
              leading: Radio<Themes>(
                value: Themes.light,
                groupValue: _currentTheme,
                onChanged: (Themes? value) {
                  setState(() {
                    _currentTheme = value;
                    ThemeSettings.changeTheme(0);
                    final snackBarThemeChange = SnackBar(
                      content: Text('Theme will be changed on restart'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBarThemeChange);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Dark'),
              leading: Radio<Themes>(
                value: Themes.dark,
                groupValue: _currentTheme,
                onChanged: (Themes? value) {
                  setState(() {
                    _currentTheme = value;
                    ThemeSettings.changeTheme(1);
                    final snackBarThemeChange = SnackBar(
                      content: Text('Theme will be changed on restart'),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBarThemeChange);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _feedbackDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Feedback"),
          content: TextField(
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(hintText: "Feedback"),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              child: const Text('Submit'),
              onPressed: () {
                setState(() {
                  final snackBarFeedback = SnackBar(
                    content: Text('Feedback sent'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarFeedback);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _bugDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Report a bug"),
          content: TextField(
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(hintText: "bug"),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              child: const Text('Submit'),
              onPressed: () {
                setState(() {
                  final snackBarFeedback = SnackBar(
                    content: Text('Bug report sent'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarFeedback);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _aboutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("About the app"),
            content: const Text("Release date: tbd\nCurrent Version: 0.1"));
      },
    );
  }
}
