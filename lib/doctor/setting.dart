import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/login.dart';
import 'package:health_center/main.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  void signOut(context) async {
    late Authentication auth;
    auth = Authentication();
    await auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

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
              title: 'User Informations',
              leading: Icon(Icons.email),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSettings()),
                );
              },
            ),
            SettingsTile(
              title: 'Change Password',
              leading: Icon(Icons.password),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            SettingsTile(
              title: 'Sign out',
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) {
                signOut(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EmailSettings extends StatefulWidget {
  const EmailSettings({Key? key}) : super(key: key);

  @override
  _EmailSettingsState createState() => _EmailSettingsState();
}

class _EmailSettingsState extends State<EmailSettings> {
  UserDetail userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");
  late Authentication auth;

  bool _warningMessage = false;
  late List<AppointmentwithName> allData = [];
  late String userDataID;
  String warningMEssageValue = "";
  TextEditingController changedFname = new TextEditingController();
  TextEditingController changedLname = new TextEditingController();

  TextEditingController changedPhone = new TextEditingController();
  TextEditingController changedSpeciality = new TextEditingController();

  @override
  initState() {
    try {
      auth = Authentication();
      FirestoreHelper.getUserData().then((data) {
        print(data[0].id);
        setState(() {
          userDataID = data[0].id;
          userData = data[0];
        });

        print("ASFAF" + userDataID);
      });
    } catch (error) {
      print(error);
      setState(() {
        userData = UserDetail("id", "fname", "lname", "email", "password",
            "phone", "userType", "speciality");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                child: Text(
                  warningMEssageValue,
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                visible: _warningMessage,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.email,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedFname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.fname,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedLname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.lname,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.phone,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedSpeciality,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.speciality,
                    ),
                  )),
              InkWell(
                onTap: () {
                  updateUser();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent])),
                  child: const Center(
                    child: Text(
                      "Save Information",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void updateUser() async {
    var data = UserDetail(
      userData.id,
      changedFname.text.isEmpty ? userData.fname : changedFname.text,
      changedLname.text.isEmpty ? userData.lname : changedLname.text,
      userData.email,
      userData.password,
      changedPhone.text.isEmpty ? userData.phone : changedPhone.text,
      userData.userType,
      changedSpeciality.text.isEmpty
          ? userData.speciality
          : changedSpeciality.text,
    );

    await FirestoreHelper.updateUserItems(userDataID, data).then((update) => {
          if (update == true)
            {
              setState(() {
                _warningMessage = true;
                warningMEssageValue = "Datas successfully updated";
              })
            }
          else
            {
              setState(() {
                _warningMessage = false;
                warningMEssageValue = "Datas not updated";
              })
            }
        });
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  UserDetail userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");
  late Authentication auth;

  bool _warningMessage = false;
  late List<AppointmentwithName> allData = [];
  late String userDataID;
  String warningMEssageValue = "";
  TextEditingController changedPassword1 = new TextEditingController();
  TextEditingController changedPassword2 = new TextEditingController();

  TextEditingController changedPhone = new TextEditingController();

  @override
  initState() {
    try {
      auth = Authentication();
      FirestoreHelper.getUserData().then((data) {
        print(data[0].id);
        setState(() {
          userDataID = data[0].id;
          userData = data[0];
        });

        print("ASFAF" + userDataID);
      });
    } catch (error) {
      print(error);
      setState(() {
        userData = UserDetail("id", "fname", "lname", "email", "password",
            "phone", "userType", "speciality");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                child: Text(
                  warningMEssageValue,
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                visible: _warningMessage,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedPassword1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Password",
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedPassword2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "re-Password",
                    ),
                  )),
              InkWell(
                onTap: () {
                  updateUser();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent])),
                  child: const Center(
                    child: Text(
                      "Update Password",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void updateUser() async {
    if (changedPassword1.text == changedPassword2.text &&
        changedPassword1.text.isNotEmpty) {
      var data = UserDetail(
          userData.id,
          userData.fname,
          userData.lname,
          userData.email,
          changedPassword1.text,
          userData.phone,
          userData.userType,
          userData.speciality);

      await FirestoreHelper.updateUserItems(userDataID, data).then((update) => {
            auth
                .updatePassword(changedPassword1.text)
                .then((value) => setState(() {
                      _warningMessage = true;
                      warningMEssageValue = value;
                    }))
          });
    } else {
      setState(() {
        _warningMessage = true;
        warningMEssageValue = "Password doesnt match!";
      });
    }
  }
}
