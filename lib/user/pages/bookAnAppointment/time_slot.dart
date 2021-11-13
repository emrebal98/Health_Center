import 'dart:math';
import 'package:health_center/user/pages/bookAnAppointment/appointment.dart';
import 'package:health_center/user/pages/bookAnAppointment/confirm_appointment.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:health_center/user/pages/home.dart';

Route timeSlotRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => TimeSlotPage(),
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

class TimeSlotPage extends StatefulWidget {
  TimeSlotPage({Key? key}) : super(key: key);

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

DateTime _date =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

class _TimeSlotState extends State<TimeSlotPage> {
  List<TimeObject> timeSlotList = [];

  // DateTime _date =
  //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
        randomEnable();
      });
    }
  }

  void randomEnable() {
    final random = Random();
    for (var item in timeSlotList) {
      item.enable = random.nextBool();
    }
  }

  @override
  void initState() {
    //Add time slot items
    for (var i = 8; i < 18; i++) {
      //Exclude 13:00
      if (i != 13) {
        timeSlotList.add(TimeObject(
          i.toString().padLeft(2, '0') + ":00",
        ));
      }
      //Exclude 12:30
      if (i != 12) {
        timeSlotList.add(TimeObject(
          i.toString().padLeft(2, '0') + ":30",
        ));
      }
      //To add space betwwen morning and afternoon
      if (i == 12) {
        for (var i = 0; i < 15; i++) {
          timeSlotList.add(TimeObject.empty());
        }
      }
    }
    randomEnable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Time Slot",
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
        body: ListView(
          children: [
            Container(
              height: 80,
              // color: Colors.amberAccent,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Image.asset("lib/images/doctor9.png"),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Tawfiq Bahri",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Family Doctor, Cardiologist",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 13))
                      ],
                    ),
                  )
                ],
              ),
            ),
            DividerTitle(title: "Select a day", button: false),
            // const Padding(
            //   padding: EdgeInsets.only(bottom: 20),
            //   child: Text(
            //     "Select a day",
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            //   ),
            // ),
            Container(
                margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                height: 50,
                child: Material(
                  // type: MaterialType.transparency,
                  color: Colors.amber[300],
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      _selectDate();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          size: 36,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('EEEE, d MMM').format(_date),
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                )),
            Column(
              children: getTimeCards(timeSlotList),
            ),
          ],
        ));
  }
}

//Time Card
class TimeCard extends StatelessWidget {
  const TimeCard({Key? key, required this.time, this.enabled = true})
      : super(key: key);

  final String time;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      // width: 150,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        color: enabled ? Colors.greenAccent[400] : Colors.grey,
        clipBehavior: Clip.antiAlias,
        // type: MaterialType.transparency,
        child: InkWell(
          onTap: enabled
              ? () {
                  var newDate = _date.add(Duration(
                      hours: int.parse(time.split(":").first),
                      minutes: int.parse(time.split(":").last)));

                  Navigator.of(context).push(confirmAppointmentRoute(newDate));
                }
              : null,
          splashColor: enabled ? null : Colors.transparent,
          highlightColor: enabled ? null : Colors.transparent,
          child: Center(
              child: Text(
            time,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          )),
        ),
      ),
    ));
  }
}

//Time Class for list
class TimeObject {
  String time;
  bool enable;
  bool empty;
  TimeObject(this.time, {this.enable = true, this.empty = false});
  TimeObject.empty({this.empty = true, this.enable = false, this.time = " "});
}

//Get Time Cards
List<Widget> getTimeCards(List<TimeObject> list) {
  List<Widget> result = [];
  int len = list.length;
  for (var i = 0; i < len; i += 4) {
    TimeObject t1 = i < len ? list[i] : TimeObject.empty();
    TimeObject t2 = i + 1 < len ? list[i + 1] : TimeObject.empty();
    TimeObject t3 = i + 2 < len ? list[i + 2] : TimeObject.empty();
    TimeObject t4 = i + 3 < len ? list[i + 3] : TimeObject.empty();

    result.add(Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !t1.empty
                ? TimeCard(
                    time: t1.time,
                    enabled: t1.enable,
                  )
                : Expanded(child: Container()),
            !t2.empty
                ? TimeCard(
                    time: t2.time,
                    enabled: t2.enable,
                  )
                : Expanded(child: Container()),
            !t3.empty
                ? TimeCard(
                    time: t3.time,
                    enabled: t3.enable,
                  )
                : Expanded(child: Container()),
            !t4.empty
                ? TimeCard(
                    time: t4.time,
                    enabled: t4.enable,
                  )
                : Expanded(child: Container()),
          ],
        )));
    // if (i % 8 == 0)
    //   result.add(SizedBox(
    //     height: 50,
    //   ));
  }
  return result;
}
