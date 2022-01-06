import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  late String id;
  late String fname;
  late String lname;
  late String email;
  late String password;
  late String phone;
  late String userType;
  late String speciality;

  UserDetail(this.id, this.fname, this.lname, this.email, this.password,
      this.phone, this.userType, this.speciality);

  UserDetail.fromMap(dynamic obj) {
    id = obj.id;
    fname = obj["fname"];
    lname = obj["lname"];
    email = obj["email"];
    password = obj["password"];
    phone = obj["phone"];
    userType = obj["userType"];
    speciality = obj["speciality"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = this.id;
      map['fname'] = this.fname;
      map['lname'] = this.lname;
      map['email'] = this.email;
      map['password'] = this.password;
      map['phone'] = this.phone;
      map['userType'] = this.userType;
      map['speciality'] = this.speciality;
    }
    return map;
  }
}
