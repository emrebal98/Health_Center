import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:health_center/doctor/appointmentList.dart';
import 'package:health_center/doctor/perscriptionList.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/Perscription.dart';
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

  late List<Appointment> appointments = [];
  late List<AppointmentwithName> allData = [];

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
      FirestoreHelper.getAppointmentsWithName().then((data) {
        //print("123.---" + data.length.toString());
        setState(() {
          allData = data;
        });
        FirestoreHelper.getMyAppointmentsDoc().then((data) {
          //print("12.---" + data.length.toString());
          setState(() {
            appointments = data;
          });
          //print("object+124124" + allData.length.toString());
        });
      });
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
                                "lib/images/patient3.png",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: allData
                          .map(
                            (patient) => PatientCard(
                              imageName: "patient3",
                              patientName: patient.patientName,
                              patientstatus: patient.status,
                              appdate: patient.date,
                              apptime: patient.time,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                InkWell(
                  child: DividerTitle1(
                    title: "Given Perscriptions",
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
            Image.asset("lib/images/patient3.png"),
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

class DividerTitle1 extends StatelessWidget {
  const DividerTitle1(
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
                  Navigator.of(context).push(perscriptionListRoute());
                },
                child: const Text("See All",
                    style: TextStyle(fontWeight: FontWeight.w400)))
            : Container(),
      ]),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard(
      {Key? key,
      required this.imageName,
      required this.patientName,
      required this.patientstatus,
      required this.appdate,
      required this.apptime})
      : super(key: key);

  final String imageName, patientName, patientstatus, appdate, apptime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), //color of shadow
              spreadRadius: 2, //spread radius
              blurRadius: 3, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              "lib/images/" + imageName + ".png",
              height: 60,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            patientName,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Text(
            patientstatus,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          ),
          Text(
            appdate,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          ),
          Text(
            apptime,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
