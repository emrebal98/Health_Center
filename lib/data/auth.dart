import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_center/data/add_data.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  createUser(String fname, String lname, String email, String password,
      String phone, String userType, String speciality) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("Users").doc(user.user!.uid).set(
      {
        'fname': fname,
        'lname': lname,
        'email': email,
        'password': password,
        'phone': phone,
        'userType': userType,
        'speciality': speciality
      },
    );
    return user.user;
  }
}
