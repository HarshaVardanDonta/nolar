// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nolar/screens/home.dart';
import 'package:nolar/w.dart';
import 'package:pinput/pinput.dart';

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
  TextEditingController patientName = TextEditingController();
  TextEditingController hospName = TextEditingController();
  TextEditingController patientAge = TextEditingController();
  TextEditingController reasonForRequest = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  String selectedBlood = dropItems.first;
  String selectedReq = dropForReq.first;
  bool selectedBloodButton = true;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                child: T1(content: "Request", color: Colors.white)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        //blood group
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedBloodButton = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            decoration: BoxDecoration(
                              color: selectedBloodButton
                                  ? Colors.red
                                  : Colors.grey[500],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Blood Group",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 17,
                                          color: selectedBloodButton
                                              ? Colors.white
                                              : Colors.black,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: selectedBloodButton
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        //blood type
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedBloodButton = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            decoration: BoxDecoration(
                              color: selectedBloodButton
                                  ? Colors.grey[500]
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Blood Type",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 17,
                                          color: selectedBloodButton
                                              ? Colors.black
                                              : Colors.white,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: selectedBloodButton
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    flex: 3,
                    child: selectedBloodButton
                        ? AnimatedContainer(
                            duration: Duration(seconds: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //a+ and a-
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("A+");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "A+",
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("A-");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "A-",
                                                color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                                //ab+ and ab-
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("AB+");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "AB+",
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("AB-");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "AB-",
                                                color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                                //b+ and b-
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("B+");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "B+",
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("B-");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "B-",
                                                color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                                //o+ and o-
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("O+");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "O+",
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          bloodGroup.setText("O-");
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                            child: T1(
                                                content: "O-",
                                                color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        : AnimatedContainer(
                            duration: Duration(seconds: 1),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            reasonForRequest.setText("Plasma");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                              child: T1(
                                                  content: "Plasma",
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            reasonForRequest
                                                .setText("Whole Blood");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                              child: T1(
                                                  content: "Whole",
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            reasonForRequest
                                                .setText("Platelets");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                              child: T1(
                                                  content: "Platelets",
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            reasonForRequest.setText("RRCB");
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                              child: T1(
                                                  content: "RRBC",
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: RegisterTextField(
                      content: "Patient Name", controller: patientName),
                ),
                Flexible(
                    flex: 1,
                    child: RegisterTextField(
                        content: "Age", controller: patientAge)),
              ],
            ),
            RegisterTextField(content: "Hospital Name", controller: hospName),
            //preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    T1(content: "Preview", color: Colors.black),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                T1(
                                    content: "Blood Group : ",
                                    color: Colors.white),
                                T1(
                                    content: bloodGroup.text.toString(),
                                    color: Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                T1(content: "Reason : ", color: Colors.white),
                                T1(
                                    content: reasonForRequest.text.toString(),
                                    color: Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                T1(
                                    content: "Patient Name : ",
                                    color: Colors.white),
                                T1(
                                    content: patientName.text.toString(),
                                    color: Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                T1(content: "Age : ", color: Colors.white),
                                T1(
                                    content: patientAge.text.toString(),
                                    color: Colors.white),
                              ],
                            ),
                            Row(
                              children: [
                                T1(
                                    content: "Hospital Name : ",
                                    color: Colors.white),
                                T1(
                                    content: hospName.text.toString(),
                                    color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () async {
                          if (patientName.text != '' &&
                              patientAge.text != '' &&
                              hospName.text != '' &&
                              bloodGroup.text != '' &&
                              reasonForRequest.text != '') {
                            await FirebaseFirestore.instance
                                .collection("request")
                                .doc("${currentUser?.phoneNumber}")
                                .set({
                              "Patient Name": patientName.text.toString(),
                              "Age": patientAge.text.toString(),
                              "Hospital Name": hospName.text.toString(),
                              "BloodGroup": bloodGroup.text.toString(),
                              "Reason": reasonForRequest.text.toString(),
                              "phone": currentUser?.phoneNumber
                                  .toString()
                                  .substring(3),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: T1(
                              content: "Request placed",
                              color: Colors.redAccent,
                            )));
                            patientAge.clear();
                            patientName.clear();
                            hospName.clear();
                            bloodGroup.clear();
                            reasonForRequest.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(milliseconds: 300),
                                content: T1(
                                  content: "Fill all details",
                                  color: Colors.redAccent,
                                )));
                          }
                        },
                        child: Center(
                            child: T1(content: "Request", color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
