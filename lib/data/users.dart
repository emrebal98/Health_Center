import 'package:cloud_firestore/cloud_firestore.dart';

class Usersdata {
  String id;
  String fname;
  String lname;
  String email;
  String password;
  String phone;
  String userType;
  String speciality;

  Usersdata(
      {this.id = '',
      this.fname = '',
      this.lname = '',
      this.email = '',
      this.password = '',
      this.phone = '',
      this.userType = '',
      this.speciality = ''});

  factory Usersdata.fromSnapshot(DocumentSnapshot snapshot) {
    return Usersdata(
      id: snapshot.id,
      fname: snapshot["fname"],
      lname: snapshot["lname"],
      email: snapshot["email"],
      password: snapshot["password"],
      phone: snapshot["phone"],
      userType: snapshot["userType"],
      speciality: snapshot["speciality"],
    );
  }
}
