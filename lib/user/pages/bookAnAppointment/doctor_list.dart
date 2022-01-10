import 'package:flutter/material.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:health_center/user/pages/home.dart';

Route doctorListRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DoctorListPage(),
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

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  late List<UserDetail> doctors = [
    UserDetail("id", "fname", "lname", "email", "password", "phone", "userType",
        "speciality")
  ];
  late Authentication auth;
  @override
  initState() {
    auth = Authentication();
    FirestoreHelper.getDoctors().then((data) {
      setState(() {
        doctors = data;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Doctor",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
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
      body: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, position) {
            return DoctorListCard(
              imageName: "doctor1",
              doctorMail: doctors[position].email,
              doctorName:
                  doctors[position].fname + " " + doctors[position].lname,
              doctorDesc: doctors[position].speciality,
            );
          }),
    );
  }
}

//Doctor List Card
class DoctorListCard extends StatelessWidget {
  const DoctorListCard(
      {Key? key,
      required this.imageName,
      required this.doctorName,
      required this.doctorMail,
      required this.doctorDesc})
      : super(key: key);

  final String imageName, doctorName, doctorDesc, doctorMail;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: Colors.black.withAlpha(20)),
      )),
      height: 100,
      child: Material(
          child: InkWell(
              onTap: () {
                //!
                Navigator.of(context).push(timeSlotRoute(
                    Doctor(doctorName, doctorDesc, imageName, doctorMail)));
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Image.asset("lib/images/" + imageName + ".png"),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(doctorDesc,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 13))
                      ],
                    ),
                  )
                ]),
              ))),
    );
  }
}
