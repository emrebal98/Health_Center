import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/model/Perscription.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:intl/intl.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<List<UserDetail>> getUserList() async {
    List<UserDetail> details = [];
    var data = await db.collection('users').get();

    if (data != null) {
      details =
          data.docs.map((document) => UserDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      print(detail);
      detail.id = data.docs[i].id;
    });

    return details;
  }

  static Future<List<UserDetail>> getUserData() async {
    late Authentication auth = Authentication();
    late String user_email;
    await auth.getUser().then((user) {
      user_email = user!.email.toString();
    });

    List<UserDetail> details = [];
    var data = await db.collection('users').get();

    if (data != null) {
      details =
          data.docs.map((document) => UserDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
    });

    details = details.where((element) => element.email == user_email).toList();
    return details;
  }

  static Future<List<UserDetail>> getDoctors() async {
    //late Authentication auth = Authentication();
    //late String user_email;
    //await auth.getUser().then((user) {
    //  user_email = user!.email.toString();
    //});

    List<UserDetail> details = [];
    var data = await db.collection('users').get();

    if (data != null) {
      details =
          data.docs.map((document) => UserDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
    });

    details = details.where((element) => element.userType == "Doctor").toList();
    return details;
  }

  ///Gets the user according to given email
  static Future<UserDetail> getUser(String email) async {
    List<UserDetail> details = [];
    var data = await db.collection('users').get();

    if (data != null) {
      details =
          data.docs.map((document) => UserDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
    });

    details = details.where((element) => element.email == email).toList();
    return details[0];
  }

  static Future<List<UserDetail>> getPatient() async {
    //late Authentication auth = Authentication();
    //late String user_email;
    //await auth.getUser().then((user) {
    //  user_email = user!.email.toString();
    //});

    List<UserDetail> details = [];
    var data = await db.collection('users').get();

    if (data != null) {
      details =
          data.docs.map((document) => UserDetail.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
    });

    details =
        details.where((element) => element.userType == "Patient").toList();
    return details;
  }

  static Future addNewEvent(UserDetail eventDetail) {
    var result = db
        .collection('users')
        .add(eventDetail.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<UserDetail>> deleteEvent(String documentId) async {
    await db.collection('users').doc(documentId).delete();
    return getUserList();
  }

// ############################ APPOINTMENT PART ######################################
// ############################ APPOINTMENT PART ######################################
// ############################ APPOINTMENT PART ######################################
// ############################ APPOINTMENT PART ######################################
// ############################ APPOINTMENT PART ######################################

  static Future addNewAppointment(Appointment appointment) {
    var result = db
        .collection('appointments')
        .add(appointment.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<Appointment>> getMyAppointments() async {
    late Authentication auth = Authentication();
    late String user_email;
    await auth.getUser().then((user) {
      user_email = user!.email.toString();
    });
    List<Appointment> appointments = [];
    var data = await db.collection('appointments').get();

    if (data != null) {
      appointments =
          data.docs.map((document) => Appointment.fromMap(document)).toList();
    }

    // Update status of the appointment if date is before now
    var idsForUpdate = appointments
        .where((element) => DateTime.parse(element.date).isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)))
        .toList();

    for (var item in idsForUpdate) {
      item.status = "Past";
      db.collection("appointments").doc(item.id).update(item.toMap());
    }

    appointments = appointments
        .where((element) => element.patientEmail == user_email.toString())
        .toList();
    appointments.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    var start = appointments
        .where((element) => element.status.contains("Pending"))
        .toList();

    var end = appointments
        .where((element) => !element.status.contains("Pending"))
        .toList();
    // appointments.sort((a, b) => b.status.compareTo(a.status));

    return [...start, ...end];
  }

  ///Gets the past appointments of the patient
  static Future<List<Appointment>> getPastAppointments() async {
    late Authentication auth = Authentication();
    late String user_email;
    await auth.getUser().then((user) {
      user_email = user!.email.toString();
    });
    List<Appointment> appointments = [];
    var data = await db.collection('appointments').get();

    if (data != null) {
      appointments =
          data.docs.map((document) => Appointment.fromMap(document)).toList();
    }

    // Update status of the appointment if date is before now
    var idsForUpdate = appointments
        .where((element) => DateTime.parse(element.date).isBefore(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)))
        .toList();

    for (var item in idsForUpdate) {
      item.status = "Past";
      db.collection("appointments").doc(item.id).update(item.toMap());
    }

    appointments = appointments
        .where((element) =>
            element.patientEmail == user_email.toString() &&
            element.status == "Past")
        .toList();
    appointments.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    // var start = appointments
    //     .where((element) => element.status.contains("Pending"))
    //     .toList();

    // var end = appointments
    //     .where((element) => !element.status.contains("Pending"))
    //     .toList();
    // appointments.sort((a, b) => b.status.compareTo(a.status));

    return appointments;
  }

  ///Gets the available time slots of the doctor
  static Future<List<String>> getAvailableTimeSlots(
      String doctorEmail, String date) async {
    //late Authentication auth = Authentication();
    //late String user_email;
    //await auth.getUser().then((user) {
    //  user_email = user!.email.toString();
    //});

    List<Appointment> result = [];
    var data = await db.collection('appointments').get();

    if (data != null) {
      result =
          data.docs.map((document) => Appointment.fromMap(document)).toList();
    }

    result = result
        .where((element) =>
            element.doctorEmail == doctorEmail &&
            element.date == date &&
            element.status == "Pending")
        .toList();

    List<String> timeSlots = [];
    result.forEach((element) {
      timeSlots.add(element.time);
    });
    return timeSlots;
  }

  ///Update the appointment according to given parameter
  static Future<void> updateAppointment(Appointment appointment) async {
    return await db
        .collection("appointments")
        .doc(appointment.id)
        .update(appointment.toMap());
  }

  ///Gets the next appointment of the user
  static Future<Appointment> getNextAppointment() async {
    late Authentication auth = Authentication();
    late String user_email;
    await auth.getUser().then((user) {
      user_email = user!.email.toString();
    });
    List<Appointment> appointments = [];
    var data = await db.collection('appointments').get();

    if (data != null) {
      appointments =
          data.docs.map((document) => Appointment.fromMap(document)).toList();
    }

    appointments = appointments
        .where((element) =>
            element.patientEmail == user_email.toString() &&
            element.status == "Pending")
        .toList();
    appointments.sort((a, b) => a.time.compareTo(b.time));
    appointments.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return appointments[0];
  }

// ############################ PERSCRIPTION PART ######################################
// ############################ PERSCRIPTION PART ######################################
// ############################ PERSCRIPTION PART ######################################
// ############################ PERSCRIPTION PART ######################################
// ############################ PERSCRIPTION PART ######################################
  static Future addNewPercription(Perscription prescription) {
    var result = db
        .collection('perscriptions')
        .add(prescription.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<Perscription>> getPatientPerscription(patientMail) async {
    List<Perscription> perscription = [];
    var data = await db.collection('perscriptions').get();

    if (data != null) {
      perscription =
          data.docs.map((document) => Perscription.fromMap(document)).toList();
    }

    perscription = perscription
        .where((element) => element.patientMail == patientMail.toString())
        .toList();
    return perscription;
  }
}
