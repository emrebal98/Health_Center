import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:health_center/doctor/appointmentList.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/home.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:intl/intl.dart';

class DoctorRoute extends StatefulWidget {
  const DoctorRoute({Key? key}) : super(key: key);

  @override
  _DoctorRouteState createState() => _DoctorRouteState();
}

class _DoctorRouteState extends State<DoctorRoute> {
  UserDetail userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");
  late Authentication auth;

  Appointment? nextDocAppointment;
  UserDetail? nextPatient;

  void updateNextDocAppointment() {
    setState(() {
      FirestoreHelper.getNextDocAppointment().then((value) {
        nextDocAppointment = value;
        getPatient(value.patientEmail);
      });
    });
  }

  void getPatient(String patientEmail) {
    FirestoreHelper.getUser(patientEmail)
        .then((value) => setState(() => nextPatient = value));
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  initState() {
    try {
      auth = Authentication();
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
    if (mounted) {
      updateNextDocAppointment();
    }
    print(nextDocAppointment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.health_and_safety_outlined,
              size: 32,
            ),
            Text(
              "Health Center",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: ScrollConfiguration(
        behavior: MyScrollBehavior(),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle_rounded,
                        size: 64,
                        color: Colors.blue,
                      ),
                      Text(
                        "Hello," + userData.fname + " " + userData.lname,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const DividerTitle(
                  title: "Next appointment",
                  button: false,
                  left: 20,
                  top: 15,
                  right: 0,
                  bottom: 0,
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: HexColor("#2E83F8"),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextDocAppointment != null
                              ? (calculateDifference(DateTime.parse(
                                          nextDocAppointment!.date)) ==
                                      0
                                  ? "Today"
                                  : calculateDifference(DateTime.parse(
                                              nextDocAppointment!.date)) ==
                                          1
                                      ? "Tomorrow"
                                      : calculateDifference(DateTime.parse(
                                                  nextDocAppointment!.date))
                                              .toString() +
                                          " Days Remaining")
                              : "Loading...",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          nextDocAppointment != null
                              ? DateFormat("dd MMM yyyy").format(DateTime.parse(
                                      nextDocAppointment!.date)) +
                                  " " +
                                  nextDocAppointment!.time
                              : "Loading...",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: Colors.white24,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "lib/images/doctor1.png",
                                height: 60,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nextPatient != null
                                          ? nextPatient!.fname +
                                              " " +
                                              nextPatient!.lname
                                          : "Loading...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ]),
                ),
                InkWell(
                  onTap: () => print("Samet"),
                  child: DividerTitle(
                    title: "Next Patients",
                    button: true,
                    top: 5,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DividerTitle extends StatelessWidget {
  const DividerTitle(
      {Key? key,
      required this.title,
      required this.button,
      this.left = 20,
      this.top = 15,
      this.right = 20,
      this.bottom = 20})
      : super(key: key);

  final String title;
  final bool button;
  final double left, top, right, bottom;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, top: top, bottom: bottom, right: right),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        button
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).push(appointmentListRoute());
                },
                child: const Text("See All",
                    style: TextStyle(fontWeight: FontWeight.w400)))
            : Container(),
      ]),
    );
  }
}

class OtherPatients extends StatelessWidget {
  const OtherPatients(
      {Key? key,
      required this.imageName,
      required this.patientName,
      required this.sex,
      required this.age})
      : super(key: key);

  final String imageName, patientName, sex;
  final int age;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: HexColor("#EBF2F5"),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("lib/images/doctor9.png"),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(age.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13)),
                  Text(sex,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 13))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
