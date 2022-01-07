import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  late String date;
  late String doctorEmail;
  late String doctorSpeciality;
  late String patientEmail;
  late String time;
  late String status;

  Appointment(this.date, this.doctorEmail, this.doctorSpeciality,
      this.patientEmail, this.time, this.status);

  Appointment.fromMap(dynamic obj) {
    date = obj.data()["date"].toString();
    doctorEmail = obj.data()["doctorEmail"].toString();
    doctorSpeciality = obj.data()["doctorSpeciality"].toString();
    patientEmail = obj.data()["patientEmail"].toString();
    time = obj.data()["time"].toString();
    status = obj.data()['status'].toString();
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['date'] = this.date;
    map['doctorEmail'] = this.doctorEmail;
    map['doctorSpeciality'] = this.doctorSpeciality;
    map['patientEmail'] = this.patientEmail;
    map['time'] = this.time;
    map['status'] = this.status;

    return map;
  }
}
