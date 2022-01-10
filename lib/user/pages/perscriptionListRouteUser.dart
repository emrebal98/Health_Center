import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/helper/scroll_behavior.dart';
import 'package:health_center/model/Appointment.dart';
import 'package:health_center/model/Perscription.dart';
import 'package:health_center/model/UserDetail.dart';
import 'package:health_center/shared/authentication.dart';
import 'package:health_center/shared/firestore_helper.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:health_center/user/pages/home.dart';

Route perscriptionListRouteUser() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PerscriptionUserPage(),
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

class PerscriptionUserPage extends StatefulWidget {
  const PerscriptionUserPage({Key? key}) : super(key: key);

  @override
  _PerscriptionUserPageState createState() => _PerscriptionUserPageState();
}

class _PerscriptionUserPageState extends State<PerscriptionUserPage> {
  List<Perscription> perscriptions = [];
  late List<PerscriptionwithUserName> allData = [];

  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getUserPerscriptionWithName().then((data) {
        //print("123.---" + data.length.toString());
        setState(() {
          allData = data;
        });
        FirestoreHelper.getPatient1Perscription().then((data) {
          print(data);
          setState(() {
            perscriptions = data;
          });
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
            "Perscriptions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: Colors.transparent,
        ),
        body: ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: allData.isNotEmpty
                ? (ListView.builder(
                    itemCount: allData.length,
                    itemBuilder: (context, index) {
                      final item = allData[index];
                      return AbsorbPointer(
                        absorbing: false,
                        child: Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            print(allData[index].code);
                            deletePerscription(allData[index].code)
                                .then((value) => print(value));
                          },
                          background: Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 5),
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [],
                              )),
                          child: perscriptions.isEmpty != true
                              ? ListTile(
                                  title: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: HexColor("#EBF2F5"),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipOval(
                                                    child: Image.asset(
                                                      "lib/images/medical-care.png",
                                                      height: 60,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Doctor Name : " +
                                                            item.doctorEmail,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                            "Description : " +
                                                                item.description),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
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
                  ))
                : (Center(
                    child: Text("No Recorded prescription"),
                  ))));
  }

  Future deletePerscription(String id) async {
    FirestoreHelper.detePerscription(id).then((value) => value);
  }
}
