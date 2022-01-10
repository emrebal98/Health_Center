import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/doctor/doctor.dart';
import 'package:health_center/doctor/setperscription.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';

Route perscriptionRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        PerscriptiontPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
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

class PerscriptiontPage extends StatefulWidget {
  const PerscriptiontPage({Key? key}) : super(key: key);

  @override
  _PerscriptiontPageState createState() => _PerscriptiontPageState();
}

class _PerscriptiontPageState extends State<PerscriptiontPage> {
  late List<UserDetail> patientslist = [
    UserDetail("id", "fname", "lname", "email", "password", "phone", "userType",
        "speciality"),
    UserDetail("id", "fname", "lname", "email", "password", "phone", "userType",
        "speciality")
  ];
  late Authentication auth;
  @override
  initState() {
    auth = Authentication();

    FirestoreHelper.getPatient().then((data) {
      setState(() {
        patientslist = data;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Give Prescription",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: setPerscriptions(patientslist),
      ),
    );
  }
}

class PatientsCard extends StatelessWidget {
  const PatientsCard(
      {Key? key,
      required this.imageName,
      required this.patientsName,
      required this.patientMail,
      this.empty = false})
      : super(key: key);
  final String imageName, patientsName, patientMail;
  final bool empty;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !empty
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 300,
              height: 80,
              child: Material(
                  color: HexColor("#EBF2F5"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            setPerscriptionRoute(patientsName, patientMail));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(children: [
                          ClipOval(
                            child: Image.asset(
                              "lib/images/" + imageName + ".png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.16,
                              child: AutoSizeText(
                                patientsName,
                                // overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          )
                        ]),
                      ))),
            )
          : Container(),
    );
  }
}

List<Widget> setPerscriptions(List<UserDetail> list) {
  int len = list.length;
  // int rowCount = len ~/ 2;
  List<Widget> result = [];

  //Divider title
  result.add(const DividerTitle(
    title: "Choose a patient to set Prescription",
    button: false,
    bottom: 0,
  ));

  //Health Concern Cards
  for (var i = 0; i < len; i += 1) {
    result.add(Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PatientsCard(
            imageName: "patient3",
            patientsName: list[i].fname + " " + list[i].lname,
            patientMail: list[i].email,
            empty: !(i < len),
          ),
        ],
      ),
    ));
  }

  return result;
}
