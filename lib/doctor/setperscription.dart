import 'package:flutter/material.dart';
import 'package:health_center/doctor/perscription.dart';
import 'package:health_center/doctor/perscriptionList.dart';
import 'package:health_center/model/Perscription.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/firestore_helper.dart';

Route setPerscriptionRoute(String patientName, String patientMail) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SetPerscription(patientName: patientName, patientMail: patientMail),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class SetPerscription extends StatefulWidget {
  const SetPerscription(
      {Key? key, required this.patientName, required this.patientMail})
      : super(key: key);
  final String patientName;
  final String patientMail;
  @override
  _SetPerscriptionState createState() => _SetPerscriptionState();
}

class _SetPerscriptionState extends State<SetPerscription> {
  UserDetail? userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");

  TextEditingController setPerscription = new TextEditingController();

  @override
  initState() {
    try {
      FirestoreHelper.getUserData().then((data) {
        print(data[0].userType);
        setState(() {
          userData = data[0];
        });
      });
    } catch (error) {
      print(error);
      setState(() {
        userData = UserDetail("id", "fname", "lname", "email", "password",
            "phone", "userType", "speciality");
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perscription Page",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blue,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        children: [
          Container(
            height: 80,
            // color: Colors.amberAccent,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Image.asset("lib/images/patient3.png"),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.patientName,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 150,
              color: Colors.white,
              child: TextField(
                maxLines: 10,
                controller: setPerscription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Set Perscription",
                ),
              )),
          ElevatedButton.icon(
            onPressed: () {
              print('add perscription');
              if (setPerscription.text.isEmpty) {
                print("please add perscription description");
              } else {
                try {
                  final Perscription newPerscription = Perscription(
                      "code",
                      userData!.email,
                      userData!.speciality,
                      widget.patientMail,
                      setPerscription.text);
                  FirestoreHelper.addNewPercription(newPerscription);
                } catch (errorMessage) {
                  print('Error: $errorMessage');
                }
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Perscription'),
          ),
        ],
      ),
    );
  }
}
