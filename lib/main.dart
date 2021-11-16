import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.home = const Login()}) : super(key: key);
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Center',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
