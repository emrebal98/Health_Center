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

Route perscriptionListRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const PerscriptionPage(),
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

class PerscriptionPage extends StatefulWidget {
  const PerscriptionPage({Key? key}) : super(key: key);

  @override
  _PerscriptionPageState createState() => _PerscriptionPageState();
}

class _PerscriptionPageState extends State<PerscriptionPage> {
  List<Perscription> perscriptions = [];
  late List<PerscriptionwithName> allData = [];

  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getPerscriptionWithName().then((data) {
        //print("123.---" + data.length.toString());
        setState(() {
          allData = data;
        });
        FirestoreHelper.getDoctorPerscription().then((data) {
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
          automaticallyImplyLeading: false,
        ),
        body: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: ListView.builder(
            itemCount: allData.length,
            itemBuilder: (context, index) {
              final item = allData[index];
              return AbsorbPointer(
                absorbing: false,
                child: Dismissible(
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: UniqueKey(),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.

                  //Swipe side widget
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                                item.patientName,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(item.description),
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
          ),
        ));
  }

  deletetedPerscription(Perscription perscription) {
    perscriptions.insert(0, perscription);
  }
}
