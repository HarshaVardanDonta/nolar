// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nolar/screens/home.dart';
import 'package:nolar/w.dart';

List<String> dropItems = [
  "Select Blood Group",
  "A+",
  "A-",
  "B+",
  "B-",
  "AB+",
  "AB-",
  "O+",
  "O-"
];
List<String> dropForReq = [
  "Select Reason",
  "Plasma",
  "Whole Blood",
  "Platelets",
  "Double RBC",
];

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool forPlatlets = false;
  bool forPlasma = false;

  TextEditingController patientName = TextEditingController();
  TextEditingController hospName = TextEditingController();
  TextEditingController hospLocation = TextEditingController();
  String selectedBlood = dropItems.first;
  String selectedReq = dropForReq.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/logo3.png"),
                SizedBox(height: 20),
                T1(content: "Request blood", color: Colors.redAccent),
                SizedBox(height: 20),
                RegisterTextField(
                    content: "Name of the patient", controller: patientName),
                RegisterTextField(
                    content: "Hospital Name", controller: hospName),
                RegisterTextField(
                    content: "Hospital Location", controller: hospLocation),
                PopupMenuButton(
                  tooltip: "Select blood type",
                  offset: Offset(1,0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  onSelected: (index) {
                    setState(() {
                      selectedBlood = dropItems[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: Colors.redAccent, width: 1.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedBlood,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (BuildContext context) {
                    return List.generate(dropItems.length, (index) {
                      return PopupMenuItem(
                          value: index,
                          child: Text(
                            dropItems[index],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500)),
                          ));
                    });
                  },
                ),



                //for req
                PopupMenuButton(
                  tooltip: "Select requirement",
                  offset: Offset(1,0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  onSelected: (index) {
                    setState(() {
                      selectedReq = dropForReq[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border:
                        Border.all(color: Colors.redAccent, width: 1.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedReq,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (BuildContext context) {
                    return List.generate(dropForReq.length, (index) {
                      return PopupMenuItem(
                          value: index,
                          child: Text(
                            dropForReq[index],
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500)),
                          ));
                    });
                  },
                ),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Thank You'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          "Thank you for requesting, we'll get back to you as soon as possible,"),
                                      SizedBox(height: 10),
                                      Text(
                                          "You're request is being processed"),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      hospName.clear();
                                      patientName.clear();
                                      hospLocation.clear();
                                      //TODO: navigate to activity

                                    },
                                  ),
                                ],
                              ));

                    },
                    child: T1(content: "Submit", color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
