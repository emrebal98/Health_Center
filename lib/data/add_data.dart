import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_center/data/users.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addData(String fname, String lname, String phone, String userType,
      String speciality) async {
    var ref = _firestore.collection("Users");

    var documentRef = await ref.add(
      {
        'phone': phone,
        'fname': fname,
        'lname': lname,
        'userType': userType,
        'speciality': speciality
      },
    );

    return Usersdata(
        id: documentRef.id,
        fname: fname,
        lname: lname,
        phone: phone,
        userType: userType,
        speciality: speciality);
  }
}
