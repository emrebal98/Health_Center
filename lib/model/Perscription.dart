import 'package:cloud_firestore/cloud_firestore.dart';

class Perscription {
  late String id;
  late String code;
  late String doctorMail;
  late String speciality;
  late String patientMail;
  late String description;

  Perscription(this.code, this.doctorMail, this.speciality, this.patientMail,
      this.description);

  Perscription.fromMap(dynamic obj) {
    code = obj.data()["code"].toString();
    doctorMail = obj.data()["doctorMail"].toString();
    speciality = obj.data()["speciality"].toString();
    patientMail = obj.data()["patientMail"].toString();
    description = obj.data()["description"].toString();
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['code'] = this.code;
    map['doctorMail'] = this.doctorMail;
    map['speciality'] = this.speciality;
    map['patientMail'] = this.patientMail;
    map['description'] = this.description;

    return map;
  }
}
