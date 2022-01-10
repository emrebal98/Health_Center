import 'package:flutter/material.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userType = 'Patient';
  bool _visibiltyArea = false;
  bool _visibiltyAreaMessage = false;
  String _message = "";
  late String _userId;

  TextEditingController emailController = new TextEditingController();
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();
  TextEditingController specialist = new TextEditingController();

  late Authentication auth;
  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  Future handleSubmit(context) async {
    final UserDetail newEvent = UserDetail(
        "123",
        fnameController.text,
        lnameController.text,
        emailController.text,
        passwordController.text,
        phoneNumber.text,
        userType,
        specialist.text);

    if (passwordController.text == passwordController2.text) {
      if (emailController.text.isEmpty && phoneNumber.text.isEmpty) {
        print("please fill all fields");
        setState(() {
          _message = "Please fill all fields";
          _visibiltyAreaMessage = true;
        });
      } else {
        if (userType == "Patient") {
          try {
            _userId = await auth.signUp(newEvent);
            print('Sign up for user $_userId');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } catch (errorMessage) {
            print('Error: $errorMessage');
            setState(() {
              _message = "This email registered before ";
              _visibiltyAreaMessage = true;
            });
          }
        } else {
          try {
            _userId = await auth.signUp(newEvent);
            print('Sign up for user $_userId');
          } catch (errorMessage) {
            print('Error: $errorMessage');
            setState(() {
              _message = "Error";
              _visibiltyAreaMessage = true;
            });
          }
        }
      }
    } else {
      print("Password not equals");
      setState(() {
        _message = "Password not equals";
        _visibiltyAreaMessage = true;
      });
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
                      Container(
                        child: Visibility(
                          child: Text(
                            _message,
                            style: TextStyle(color: Colors.red),
                          ),
                          visible: _visibiltyAreaMessage,
                        ),
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
                                controller: fnameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "First Name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: lnameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Last Name",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
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
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: phoneNumber,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone Number",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController2,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "RePassword",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                                child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: DropdownButton<String>(
                                hint: Text(userType),
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                isExpanded: true,
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blueAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    userType = newValue!;
                                    if (newValue == "Patient") {
                                      _visibiltyArea = false;
                                    } else {
                                      _visibiltyArea = true;
                                    }
                                  });
                                },
                                items: <String>[
                                  'Patient',
                                  'Doctor',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                            Container(
                              child: Visibility(
                                child: TextField(
                                  controller: specialist,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Specialist",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                                visible: _visibiltyArea,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          handleSubmit(context);
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
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [Colors.blue, Colors.blueAccent])),
                          child: const Center(
                            child: Text(
                              "Return to Login",
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
