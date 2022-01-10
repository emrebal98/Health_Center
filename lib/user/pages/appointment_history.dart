import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:intl/intl.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({Key? key}) : super(key: key);

  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List<Appointment> appointments = [];

  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getMyAppointments().then((data) {
        print(data);
        setState(() {
          appointments = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // items.add();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Appointments",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final item = appointments[index];
              return AbsorbPointer(
                absorbing: false,
                child: Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: UniqueKey(),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      appointments[index].status = "Cancelled";
                      FirestoreHelper.updateAppointment(appointments[index]);
                    });
                  },
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Are you sure you wish to cancel this appointment?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("YES")),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("NO"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  direction: item.status == "Pending"
                      ? DismissDirection.endToStart
                      : DismissDirection.none,
                  //Swipe side widget
                  background: Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 5),
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      )),

                  child: appointments.isEmpty != true
                      ? ListTile(
                          title: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.time,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      item.date,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor("#EBF2F5"),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                              "lib/images/doctor2.png",
                                              height: 60,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.doctorEmail,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                item.doctorSpeciality,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  "*" +
                                                      item.status
                                                          .toString()
                                                          .split(".")
                                                          .last[0]
                                                          .toUpperCase() +
                                                      item.status
                                                          .toString()
                                                          .split(".")
                                                          .last
                                                          .substring(1),
                                                  style: TextStyle(
                                                      color: item.status ==
                                                              "Cancelled"
                                                          ? Colors.red
                                                          : item.status ==
                                                                  "Pending"
                                                              ? Colors.green
                                                              : Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        timeSlotRoute(Doctor(
                                                            item.doctorEmail,
                                                            item.doctorSpeciality,
                                                            "doctor2",
                                                            item.doctorEmail)));
                                                  },
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons
                                                          .keyboard_arrow_right),
                                                      Text(
                                                          "Book an Appointment"),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                      : const SizedBox(height: 40),
                ),
              );
            },
          ),
        ));
  }
}

//Class for appointment list

