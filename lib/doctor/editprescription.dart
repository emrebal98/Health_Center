import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:health_center/helper/hex_color.dart';
import 'package:health_center/model/Perscription.dart';
import 'package:health_center/shared/firestore_helper.dart';

class EditPerscription extends StatefulWidget {
  const EditPerscription(
      {Key? key, required this.perscriptionID, required this.patientName})
      : super(key: key);
  final String perscriptionID;
  final String patientName;

  @override
  _EditPerscriptionState createState() => _EditPerscriptionState();
}

class _EditPerscriptionState extends State<EditPerscription> {
  TextEditingController setPerscription = new TextEditingController();
  late Perscription perscriptionData = Perscription(
      "code", "doctorMail", "speciality", "patientMail", "description");
  bool _warningMessage = false;
  String warningMEssageValue = "";
  @override
  void initState() {
    print("coming data->" + widget.perscriptionID);
    super.initState();
    if (mounted) {
      FirestoreHelper.getPrescriptionData(widget.perscriptionID).then((data) {
        setState(() {
          perscriptionData = data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prescription Page",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        children: [
          Container(
            height: 80,
            // color: Colors.amberAccent,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Image.asset("lib/images/patient3.png"),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.patientName,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 30,
              color: Colors.white,
              child: Text("Prescription Code: " + widget.perscriptionID)),
          Container(
              margin: const EdgeInsets.only(
                top: 20,
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 30,
              color: Colors.white,
              child: Text("Doctor Mail: " + perscriptionData.doctorMail)),
          Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 30,
              color: Colors.white,
              child: Text("Patient Mail: " + perscriptionData.patientMail)),
          Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 30,
              color: Colors.white,
              child: Text("Patient Issue: " + perscriptionData.speciality)),
          Container(
              margin: const EdgeInsets.only(
                right: 10,
                left: 10,
                bottom: 8,
              ),
              height: 150,
              color: Colors.white,
              child: TextField(
                controller: setPerscription,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: perscriptionData.description,
                ),
              )),
          Visibility(
            child: Text(
              warningMEssageValue,
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            visible: _warningMessage,
          ),
          ElevatedButton.icon(
            onPressed: () {
              var data = Perscription(
                  widget.perscriptionID,
                  perscriptionData.doctorMail,
                  perscriptionData.speciality,
                  perscriptionData.patientMail,
                  setPerscription.text.isNotEmpty
                      ? setPerscription.text
                      : perscriptionData.description);
              FirestoreHelper.updatePerscription(widget.perscriptionID, data)
                  .then((value) => {
                        value == true
                            ? (setState(() {
                                _warningMessage = true;
                                warningMEssageValue = "Prescription Edited";
                              }))
                            : (setState(() {
                                _warningMessage = true;
                                warningMEssageValue =
                                    "Prescription update fail!";
                              }))
                      });
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Edit Prescription'),
          ),
        ],
      ),
    );
  }
}
