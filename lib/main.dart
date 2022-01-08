import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:health_center/shared/authentication.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyAN5HfRloZYhMNQ4uIX7IR23PtDFyBYMAg",
  //         appId: "1:400833446688:android:9547339d28f709ff208d45",
  //         messagingSenderId: "400833446688",
  //         projectId: "myproject-b2dbc"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.home = const Login()}) : super(key: key);
  final Widget home;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget.home,
      debugShowCheckedModeBanner: false,
    );
  }
}
