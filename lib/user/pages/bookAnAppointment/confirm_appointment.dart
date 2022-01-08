import 'package:flutter/material.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:health_center/user/pages/messagesPages/success_page.dart';
import 'package:intl/intl.dart';

Route confirmAppointmentRoute(DateTime date, Doctor doctor) {
  final DateTime _date = date;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ConfirmAppointmentPage(date: _date, doctor: doctor),
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

void confirmButton(context, doctorMail, date, time, speciality, patientMail) {
  try {
    final Appointment newAppointment =
        Appointment(date, doctorMail, speciality, patientMail, time, "Pending");
    FirestoreHelper.addNewAppointment(newAppointment);
  } catch (errorMessage) {
    print('Error: $errorMessage');
  }
  Navigator.of(context).push(successPageRoute());
}

class ConfirmAppointmentPage extends StatefulWidget {
  const ConfirmAppointmentPage(
      {Key? key, required this.date, required this.doctor})
      : super(key: key);

  final DateTime date;
  final Doctor? doctor;

  @override
  _ConfirmAppointmentState createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointmentPage> {
  UserDetail? userData = UserDetail("id", "fname", "lname", "email", "password",
      "phone", "userType", "speciality");
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
            "Confirm Appointment",
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
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 80,
                  // color: Colors.amberAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset("lib/images/doctor9.png"),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.doctor!.name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                  // height: 50,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoCard(
                        title: "Doctor Email",
                        desc: widget.doctor!.email,
                      ),
                      InfoCard(
                        title: "Date",
                        desc: DateFormat('dd.MM.yyyy').format(widget.date),
                      ),
                      InfoCard(
                        title: "Time",
                        desc: DateFormat('HH:mm').format(widget.date),
                      ),
                      InfoCard(
                        title: "Health Concern",
                        desc: widget.doctor!.desc,
                      ),
                      InfoCard(
                          title: "This appointment for:",
                          desc: userData!.fname +
                              " " +
                              userData!.lname +
                              " - " +
                              userData!.email),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      confirmButton(
                          context,
                          widget.doctor!.email,
                          DateFormat('yyyy-MM-dd').format(widget.date),
                          DateFormat('HH:mm').format(widget.date),
                          widget.doctor!.desc,
                          userData!.email);
                    },
                    child: const Text(
                      "Confirm",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    )),
              ),
            )
          ],
        ));
  }
}

//Info Card
class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.title, required this.desc})
      : super(key: key);

  final String title, desc;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.black.withAlpha(40),
          thickness: 0.4,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          desc,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
