import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/user/pages/bookAnAppointment/doctor_list.dart';

import 'package:health_center/user/pages/home.dart';

// class AppointmentRoute extends CupertinoPageRoute {
//   AppointmentRoute()
//       : super(builder: (BuildContext context) => AppointmentPage());

//   // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return SlideTransition(position: animation.)
//     RotationTransition(
//         turns: animation,
//         child: ScaleTransition(
//           scale: animation,
//           child: FadeTransition(
//             opacity: animation,
//             child: AppointmentPage(),
//           ),
//         ));
//   }
// }

Route appointmentRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AppointmentPage(),
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

class AppointmentPage extends StatelessWidget {
  AppointmentPage({Key? key}) : super(key: key);

  final List<HealthConcern> healthConcernList = [
    HealthConcern("", "name1"),
    HealthConcern("", "name2"),
    HealthConcern("", "name3")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book an appointment",
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
        children: getHealthConcerns(healthConcernList),
      ),
    );
  }
}

// HealthConcernCard
class HealthConcernCard extends StatelessWidget {
  const HealthConcernCard(
      {Key? key,
      required this.imageName,
      required this.healthConcerName,
      this.empty = false})
      : super(key: key);
  final String imageName, healthConcerName;
  final bool empty;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !empty
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              // width: 300,
              height: 80,
              child: Material(
                  color: HexColor("#EBF2F5"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(doctorListRoute());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(children: [
                          Image.asset("lib/images/" + imageName + ".png"),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(healthConcerName),
                          )
                        ]),
                      ))),
            )
          : Container(),
    );
  }
}

//HealthConcern class for list
class HealthConcern {
  String imageName;
  String healthConcerName;
  HealthConcern(this.imageName, this.healthConcerName);
}

//Get HealthConcernCard according to data
List<Widget> getHealthConcerns(List<HealthConcern> list) {
  int len = list.length;
  // int rowCount = len ~/ 2;
  List<Widget> result = [];

  //Divider title
  result.add(const DividerTitle(
    title: "Choose a health concern",
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
          HealthConcernCard(
            imageName: i < len
                ? list[i].imageName.isNotEmpty
                    ? list[i].imageName
                    : "doctor9"
                : "",
            healthConcerName: i < len ? list[i].healthConcerName : "",
            empty: !(i < len),
          ),
          HealthConcernCard(
            imageName: i + 1 < len
                ? list[i + 1].imageName.isNotEmpty
                    ? list[i + 1].imageName
                    : "doctor9"
                : "",
            healthConcerName: i + 1 < len ? list[i + 1].healthConcerName : "",
            empty: !(i + 1 < len),
          ),
        ],
      ),
    ));
  }

  return result;
}
