import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:intl/intl.dart';

class PrescriptionHistory extends StatefulWidget {
  const PrescriptionHistory({Key? key}) : super(key: key);

  @override
  _PrescriptionHistoryState createState() => _PrescriptionHistoryState();
}

class _PrescriptionHistoryState extends State<PrescriptionHistory> {
  List<Prescription> items = [
    Prescription(
        DateTime.parse("2021-05-14 14:00:00"),
        "Tawfiq Bahri",
        "Tuberculosis Recipe",
        "medical-care",
        "Risus nullam eget felis eget nunc. Gravida neque convallis a cras semper. Cursus metus aliquam eleifend mi in nulla posuere sollicitudin aliquam. Lorem dolor sed viverra ipsum. Sed elementum tempus egestas sed. Volutpat ac tincidunt vitae semper quis lectus nulla at. Potenti nullam ac tortor vitae. Sed vulputate mi sit amet mauris commodo. Facilisi morbi tempus iaculis urna id volutpat lacus laoreet. Facilisi cras fermentum odio eu feugiat pretium nibh ipsum. Adipiscing at in tellus integer feugiat."),
    Prescription(
        DateTime.parse("2021-03-08 15:00:00"),
        "Mark Lee",
        "Pharyngitis Recipe",
        "medical-care",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
  ];

  @override
  Widget build(BuildContext context) {
    // items.add();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prescriptions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            // contentPadding: EdgeInsets.only(top: 10),
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                // margin: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    color: HexColor("#EBF2F5"),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "lib/images/" + item.prescriptionImage + ".png",
                            height: 60,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.prescriptionName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              item.doctorName,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Given at " +
                                    DateFormat("dd/MM/yyyy").format(item.date),
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w200),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                item.prescriptionDesc,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: item.readMore ? 20 : 3,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ),
                            item.prescriptionDesc.length > 126
                                ? TextButton(
                                    onPressed: () {
                                      setState(() {
                                        item.readMore = !item.readMore;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    child: Row(
                                      children: [
                                        Icon(item.readMore
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down),
                                        Text(item.readMore
                                            ? "Read Less"
                                            : "Read More"),
                                      ],
                                    ))
                                : const SizedBox(
                                    height: 20,
                                  ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Prescription {
  DateTime date;
  String prescriptionName;
  String prescriptionImage;
  String doctorName;
  String prescriptionDesc;
  bool readMore;
  Prescription(this.date, this.doctorName, this.prescriptionName,
      this.prescriptionImage, this.prescriptionDesc,
      {this.readMore = false});
}
