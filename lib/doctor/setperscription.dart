import 'package:flutter/material.dart';
import 'package:health_center/doctor/perscription.dart';
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
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                Image.asset("lib/images/doctor9.png"),
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
                      "description");
                  FirestoreHelper.addNewPercription(newPerscription);
                } catch (errorMessage) {
                  print('Error: $errorMessage');
                }
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Perscription'),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20, top: 30),
            child: Text(
              "Previous Perscription",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4,
            child: PreviousPerscription(patientMail: widget.patientMail),
          )
        ],
      ),
    );
  }
}

class PreviousPerscription extends StatefulWidget {
  const PreviousPerscription({Key? key, required this.patientMail})
      : super(key: key);
  final String patientMail;
  @override
  _PreviousPerscriptionState createState() => _PreviousPerscriptionState();
}

class _PreviousPerscriptionState extends State<PreviousPerscription> {
  List<Perscription> perscriptions = [];

  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getPatientPerscription(widget.patientMail).then((data) {
        print(data);
        setState(() {
          perscriptions = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (perscriptions.isEmpty) {
      return Container(
        child: Text("There is no pre perscription"),
      );
    } else {
      return Expanded(
          flex: 4,
          child: ListView.builder(
              itemCount: perscriptions.length,
              itemBuilder: (context, position) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom:
                        BorderSide(width: 1, color: Colors.black.withAlpha(20)),
                  )),
                  height: 100,
                  child: Material(
                      child: InkWell(
                          onTap: () {
                            print("clicked");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(children: [
                              Image.asset("lib/images/doctor2.png"),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      perscriptions[position].patientMail,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(perscriptions[position].description,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13))
                                  ],
                                ),
                              )
                            ]),
                          ))),
                );
              }));
    }
  }
}
