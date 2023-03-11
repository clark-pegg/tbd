import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), actions: [
        BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        )
      ]),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.account_circle),
                title: Text('Account settings'),
                onPressed: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: Text('Theme'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Choose theme'),
                value: Text('Light'),
                onPressed: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: Text('Notifications'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Notification settings'),
                onPressed: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: Text('Feedback'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('Report a bug'),
                onPressed: (value) {},
              ),
              SettingsTile.navigation(
                title: Text('Send feedback'),
                onPressed: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Text('About the app'),
                value: Text('Version 0.1'),
                onPressed: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
