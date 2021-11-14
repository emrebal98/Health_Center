import 'package:flutter/material.dart';
import 'package:health_center/user/pages/messagesPages/success_page.dart';
import 'package:intl/intl.dart';

Route confirmAppointmentRoute(DateTime date) {
  final DateTime _date = date;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ConfirmAppointmentPage(date: _date),
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

class ConfirmAppointmentPage extends StatefulWidget {
  const ConfirmAppointmentPage({Key? key, required this.date})
      : super(key: key);

  final DateTime date;
  @override
  _ConfirmAppointmentState createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointmentPage> {
  @override
  void initState() {
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
                          children: const [
                            Text(
                              "Tawfiq Bahri",
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
                        title: "Date",
                        desc: DateFormat('dd.MM.yyyy').format(widget.date),
                      ),
                      InfoCard(
                        title: "Time",
                        desc: DateFormat('HH:mm').format(widget.date),
                      ),
                      const InfoCard(
                        title: "Health Concern",
                        desc: "Physiotherapy",
                      ),
                      const InfoCard(
                        title: "This appointment for:",
                        desc: "Full Name",
                      ),
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
                      Navigator.of(context).push(successPageRoute());
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
