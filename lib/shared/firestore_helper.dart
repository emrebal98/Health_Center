import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';

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
}
