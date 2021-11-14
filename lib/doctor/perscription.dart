import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/doctor/doctor.dart';
import 'package:health_center/doctor/setperscription.dart';

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

class PerscriptiontPage extends StatelessWidget {
  PerscriptiontPage({Key? key}) : super(key: key);

  final List<Patients> patientslist = [
    Patients("", "Emre Erkan"),
    Patients("", "Samet Sarıal"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Give Perscription",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: Column(
        children: SetPerscriptions(patientslist),
      ),
    );
  }
}

class PatientsCard extends StatelessWidget {
  const PatientsCard(
      {Key? key,
      required this.imageName,
      required this.patientsName,
      this.empty = false})
      : super(key: key);
  final String imageName, patientsName;
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
                        Navigator.of(context).push(setPerscriptionRoute());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(children: [
                          Image.asset("lib/images/" + imageName + ".png"),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(patientsName),
                          )
                        ]),
                      ))),
            )
          : Container(),
    );
  }
}

class Patients {
  String imageName;
  String patientsName;
  Patients(this.imageName, this.patientsName);
}

List<Widget> SetPerscriptions(List<Patients> list) {
  int len = list.length;
  // int rowCount = len ~/ 2;
  List<Widget> result = [];

  //Divider title
  result.add(const DividerTitle(
    title: "Choose a patient to set perscription",
    button: false,
    bottom: 0,
  ));

  //Health Concern Cards
  for (var i = 0; i < len; i += 2) {
    result.add(Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PatientsCard(
            imageName: i < len
                ? list[i].imageName.isNotEmpty
                    ? list[i].imageName
                    : "doctor9"
                : "",
            patientsName: i < len ? list[i].patientsName : "",
            empty: !(i < len),
          ),
          PatientsCard(
            imageName: i + 1 < len
                ? list[i + 1].imageName.isNotEmpty
                    ? list[i + 1].imageName
                    : "doctor9"
                : "",
            patientsName: i + 1 < len ? list[i + 1].patientsName : "",
            empty: !(i + 1 < len),
          ),
        ],
      ),
    ));
  }

  return result;
}
