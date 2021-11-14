import 'package:flutter/material.dart';
import 'package:health_center/user/pages/bookAnAppointment/time_slot.dart';
import 'package:health_center/user/pages/home.dart';

Route doctorListRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DoctorListPage(),
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

class DoctorListPage extends StatelessWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Doctors",
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: ListView(
        children: const [
          DividerTitle(title: "Choose a Doctor", button: false),
          DoctorListCard(
            imageName: "doctor1",
            doctorName: "Tawfiq Bahri",
            doctorDesc: "Surgeon",
          ),
          DoctorListCard(
            imageName: "doctor2",
            doctorName: "Trashae Hubbard",
            doctorDesc: "Dentist",
          ),
          DoctorListCard(
            imageName: "doctor3",
            doctorName: "Jesus Morugai",
            doctorDesc: "Otorhinolaryngologist",
          ),
          DoctorListCard(
            imageName: "doctor6",
            doctorName: "Lisa Moreira",
            doctorDesc: "Ophthalmologist",
          ),
        ],
      ),
    );
  }
}

//Doctor List Card
class DoctorListCard extends StatelessWidget {
  const DoctorListCard(
      {Key? key,
      required this.imageName,
      required this.doctorName,
      required this.doctorDesc})
      : super(key: key);

  final String imageName, doctorName, doctorDesc;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: Colors.black.withAlpha(20)),
      )),
      height: 100,
      child: Material(
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    timeSlotRoute(Doctor(doctorName, doctorDesc, imageName)));
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Image.asset("lib/images/" + imageName + ".png"),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(doctorDesc,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 13))
                      ],
                    ),
                  )
                ]),
              ))),
    );
  }
}
