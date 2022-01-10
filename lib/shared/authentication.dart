import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/firestore_helper.dart';

class Authentication {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    UserCredential userCredentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredentials.user;
    return user?.email ?? "";
  }

  Future signUp(UserDetail userDetail) async {
    UserCredential userCredentials =
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: userDetail.email, password: userDetail.password);
    User? user = userCredentials.user;
    var user_id;
    var result = db
        .collection('users')
        .add(userDetail.toMap())
        .then((value) => user_id = value.id)
        .catchError((error) => print(error));
    print(user_id);
    return user?.uid ?? "";
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    print(user);
    return user;
  }

  Future getUserSpeciality(userEmail) async {
    var data = await FirestoreHelper.getUserList();
    return data;
  }
}
