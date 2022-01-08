import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_center/doctor/bottom_navigator.dart' as doctor_bottom;
import 'package:health_center/user/bottom_navigator.dart' as user_bottom;
import 'package:health_center/main.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/bottom_navigator.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  bool _warningMessage = false;
  late String userType;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  List<UserDetail> details = [];
  late Authentication auth;
  late UserDetail userData;
  late String patientName = "sa";
  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  Future submit(context) async {
    await auth.login("doctor@gmail.com", "samet2828");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const doctor_bottom.BottomNavigator()),
    );
    if (passwordController.text.isEmpty && emailController.text.isEmpty) {
      setState(() {
        _warningMessage = true;
      });
    } else {
      var _userEmail =
          await auth.login(emailController.text, passwordController.text);
      print('Login for user $_userEmail');
      await FirestoreHelper.getUserData().then((data) {
        print(data[0].userType);
        setState(() {
          userData = data[0];
          details = data;
        });
      });
      if (userData.userType == 'Doctor') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const doctor_bottom.BottomNavigator()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const user_bottom.BottomNavigator()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.health_and_safety_outlined,
                        size: 48,
                        color: Colors.blue,
                      ),
                      Text(
                        "Health Center",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        child: Text(
                          "Your username or password wrong!",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        visible: _warningMessage,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: _isObscure,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          submit(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent])),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent])),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
