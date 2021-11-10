import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:health_center/helper/hex_color.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key, required this.userName}) : super(key: key);
  final String userName;
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
          behavior: MyBehavior(),
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
                          "Hello, " + userName,
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
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tomorrow",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "10 January 2021, 14:30",
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
                                    children: const [
                                      Text(
                                        "Tawfiq Bahri",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Family Doctor, Cardiologist",
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
                    button: true,
                    top: 0,
                    bottom: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    // ignore: sized_box_for_whitespace
                    child: Container(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          DoctorCard(
                              imageName: "doctor1",
                              doctorName: "Tawfiq Bahri",
                              doctorDesc: "Family Doctor, Cardiologist"),
                          DoctorCard(
                              imageName: "doctor2",
                              doctorName: "Trashae Hubbard",
                              doctorDesc: "Family Doctor, Therapist"),
                          DoctorCard(
                              imageName: "doctor3",
                              doctorName: "Jesus Moruga",
                              doctorDesc: "Family Doctor, Therapist"),
                          DoctorCard(
                              imageName: "doctor4",
                              doctorName: "Gabriel Moreira",
                              doctorDesc: "Family Doctor, Therapist")
                        ],
                      ),
                    ),
                  ),
                  const DividerTitle(
                    title: "Your Prescriptions",
                    button: true,
                    top: 5,
                  ),
                  const PrescriptionCard(
                      imageName: "doctor9.png",
                      recipeName: "Tuberculosis Recipe",
                      recipeDesc: "Given by Tawfiq Bahri")
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
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
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          Text(doctorDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 13))
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

// To remove scroll effect
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
