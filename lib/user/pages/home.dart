import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/perscriptionListRouteUser.dart';
import 'package:intl/intl.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  UserDetail? userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");

  Appointment? nextAppointment;
  UserDetail? nextDoctor;
  List<UserDetail> visitedDoctors = [];

  void updateNextAppointment() {
    setState(() {
      FirestoreHelper.getNextAppointment().then((value) {
        nextAppointment = value;
        getDoctor(value.doctorEmail);
      });
    });
  }

  void getDoctor(String doctorEmail) {
    FirestoreHelper.getUser(doctorEmail)
        .then((value) => setState(() => nextDoctor = value));
  }

  void getVisitedDoctors() {
    FirestoreHelper.getPastAppointments().then((value) {
      for (var appointment in value) {
        FirestoreHelper.getUser(appointment.doctorEmail)
            .then((doctor) => setState(() => visitedDoctors.add(doctor)));
      }
    });
  }

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
    if (mounted) {
      updateNextAppointment();
      getVisitedDoctors();
    }

    super.initState();
  }

  /// Returns the difference (in full days) between the provided date and today.
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
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
              )
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
                          "Hello, " + userData!.fname + " " + userData!.lname,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  const DividerTitle(
                      title: "Next appointment",
                      button: false,
                      left: 20,
                      top: 15,
                      right: 0,
                      bottom: 0),

                  // Appointment Card
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: HexColor("#2E83F8"),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nextAppointment != null
                                ? (calculateDifference(DateTime.parse(
                                            nextAppointment!.date)) ==
                                        0
                                    ? "Today"
                                    : calculateDifference(DateTime.parse(
                                                nextAppointment!.date)) ==
                                            1
                                        ? "Tomorrow"
                                        : calculateDifference(DateTime.parse(
                                                    nextAppointment!.date))
                                                .toString() +
                                            " Days Remaining")
                                : "Loading...",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            nextAppointment != null
                                ? DateFormat("dd MMM yyyy").format(
                                        DateTime.parse(nextAppointment!.date)) +
                                    " " +
                                    nextAppointment!.time
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nextDoctor != null
                                            ? nextDoctor!.fname
                                            : "Loading...",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        nextAppointment != null
                                            ? nextAppointment!.doctorSpeciality
                                            : "Loading...",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ))
                            ],
                          )
                        ]),
                  ),

                  const DividerTitle(
                    title: "Doctors you have visited",
                    button: false,
                    top: 0,
                    bottom: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      height: 160,
                      child: visitedDoctors.isEmpty
                          ? (Center(child: Text("No Past Appointment Found!")))
                          : (ListView(
                              scrollDirection: Axis.horizontal,
                              children: visitedDoctors
                                  .map(
                                    (doctor) => DoctorCard(
                                        imageName: "doctor1",
                                        doctorName: doctor.fname,
                                        doctorDesc: doctor.speciality),
                                  )
                                  .toList())),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

//Doctor Card
class DoctorCard extends StatelessWidget {
  const DoctorCard(
      {Key? key,
      required this.imageName,
      required this.doctorName,
      required this.doctorDesc})
      : super(key: key);

  final String imageName, doctorName, doctorDesc;

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
            doctorName,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Text(doctorDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 13))
        ],
      ),
    );
  }
}

//Divider Title
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
                onPressed: () {},
                child: const Text("See All",
                    style: TextStyle(fontWeight: FontWeight.w400)))
            : Container(),
      ]),
    );
  }
}

//Prescription Card
class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard(
      {Key? key,
      required this.imageName,
      required this.recipeName,
      required this.recipeDesc})
      : super(key: key);

  final String imageName, recipeName, recipeDesc;

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
                    recipeName,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(recipeDesc,
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

class DividerTitlePrescription extends StatelessWidget {
  const DividerTitlePrescription(
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
                  Navigator.of(context).push(perscriptionListRouteUser());
                },
                child: const Text("See All",
                    style: TextStyle(fontWeight: FontWeight.w400)))
            : Container(),
      ]),
    );
  }
}
