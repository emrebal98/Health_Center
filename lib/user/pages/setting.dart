import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/login.dart';
import 'package:health_center/main.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: HexColor("#EFEFF4"),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: buildSettingsList(),
      ),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: 'Phone number',
              leading: Icon(Icons.phone),
            ),
            SettingsTile(title: 'Email', leading: Icon(Icons.email)),
            SettingsTile(
              title: 'Sign out',
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) {
                runApp(MyApp(home: Login()));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
                title: 'Terms of Service', leading: Icon(Icons.description)),
            SettingsTile(
                title: 'Open source licenses',
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
      ],
    );
  }
}
