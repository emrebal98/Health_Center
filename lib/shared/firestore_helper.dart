import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_center/model/UserDetail.dart';

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

  static Future<List<UserDetail>> getUserSpeciality(email) async {
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
