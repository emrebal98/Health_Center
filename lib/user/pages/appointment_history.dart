import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:intl/intl.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({Key? key}) : super(key: key);

  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  List<Appointment> items = [
    Appointment(DateTime.parse("2021-12-01 10:30:00"), "Tawfiq Bahri",
        "Surgeon", "doctor1", AppointmentType.pending),
    Appointment(DateTime.parse("2021-05-14 14:00:00"), "Trashae Hubbard",
        "Dentist", "doctor2", AppointmentType.cancelled),
    Appointment(DateTime.parse("2021-03-08 15:00:00"), "Jesus Morugai",
        "Otorhinolaryngologist", "doctor3", AppointmentType.past),
    Appointment(DateTime.parse("2021-01-14 16:00:00"), "Lisa Moreira",
        "Ophthalmologist", "doctor6", AppointmentType.past),
    Appointment.empty(DateTime.now())
  ];

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
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

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
                      items.removeAt(index);
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
                  direction: item.type == AppointmentType.pending
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

                  child: item.empty != true
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
                                      DateFormat("MMM dd").format(item.date),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      DateFormat("EEE. HH:mm")
                                          .format(item.date),
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
                                              "lib/images/" +
                                                  item.doctorImage +
                                                  ".png",
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
                                                item.doctorName,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                item.doctorDesc,
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
                                                      item.type
                                                          .toString()
                                                          .split(".")
                                                          .last[0]
                                                          .toUpperCase() +
                                                      item.type
                                                          .toString()
                                                          .split(".")
                                                          .last
                                                          .substring(1),
                                                  style: TextStyle(
                                                      color: item.type ==
                                                              AppointmentType
                                                                  .cancelled
                                                          ? Colors.red
                                                          : item.type ==
                                                                  AppointmentType
                                                                      .pending
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
                                                            item.doctorName,
                                                            item.doctorDesc,
                                                            item.doctorImage)));
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
enum AppointmentType { cancelled, pending, past }

class Appointment {
  DateTime date;
  String doctorName;
  String doctorImage;
  String doctorDesc;
  AppointmentType type;
  bool? empty;
  Appointment(
      this.date, this.doctorName, this.doctorDesc, this.doctorImage, this.type);
  Appointment.empty(this.date,
      {this.doctorName = "",
      this.empty = true,
      this.doctorDesc = "",
      this.doctorImage = "",
      this.type = AppointmentType.cancelled});
}
