// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nolar/screens/home.dart';
import 'package:nolar/w.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import 'dash,dart.dart';

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
  bool isSwitched = true;
  TextEditingController patientName = TextEditingController();
  TextEditingController hospName = TextEditingController();
  TextEditingController hospAddressCont = TextEditingController();
  TextEditingController patientAge = TextEditingController();
  TextEditingController reasonForRequest = TextEditingController();
  TextEditingController bloodGroup = TextEditingController();
  String selectedBlood = dropItems.first;
  String selectedReq = dropForReq.first;
  bool selectedBloodButton = true;
  bool bloodGrpSelected = false;
  bool bloodReqSelected = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> hosp = [];
  List hospAddress = [];

  fetchHosp() async {
    var result =
        await http.get(Uri.parse("https://api.npoint.io/b4ff74341b4a0c8975ef"));

    for (int i = 0; i < jsonDecode(result.body).length; i++) {
      hosp.add(jsonDecode(result.body)[i]['name'].toString());
      hospAddress.add(jsonDecode(result.body)[i]['address']);
    }
  }

  @override
  void initState() {
    fetchHosp();
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              SizedBox(
                height: 126,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //blood group
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedBloodButton = true;
                                  bloodGrpSelected = !bloodGrpSelected;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  bloodReqSelected = !bloodReqSelected;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    //a+ and a-
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              bloodGroup.setText("A+");
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 45 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 400),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 45 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 600),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 600),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                              bloodGrpSelected = false;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.ease,
                                            height: bloodGrpSelected ? 40 : 0,
                                            width: bloodGrpSelected ? 40 : 0,
                                            margin: EdgeInsets.all(5),
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
                                                reasonForRequest
                                                    .setText("Plasma");
                                                bloodReqSelected = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.ease,
                                              height: bloodReqSelected ? 40 : 0,
                                              width: bloodReqSelected ? 90 : 0,
                                              margin: EdgeInsets.all(5),
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
                                                bloodReqSelected = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.ease,
                                              height: bloodReqSelected ? 40 : 0,
                                              width: bloodReqSelected ? 90 : 0,
                                              margin: EdgeInsets.all(5),
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
                                                bloodReqSelected = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 600),
                                              curve: Curves.ease,
                                              height: bloodReqSelected ? 40 : 0,
                                              width: bloodReqSelected ? 100 : 0,
                                              margin: EdgeInsets.all(5),
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
                                                reasonForRequest
                                                    .setText("RRCB");
                                                bloodReqSelected = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 600),
                                              curve: Curves.ease,
                                              height: bloodReqSelected ? 40 : 0,
                                              width: bloodReqSelected ? 100 : 0,
                                              margin: EdgeInsets.all(5),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    } else {
                      List<String> matches = <String>[];
                      matches.addAll(hosp);
                      matches.retainWhere((s) {
                        return s
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                      return matches;
                    }
                  },
                  onSelected: (String selection) {
                    hospName.text = selection;
                    int s = hosp.indexOf(selection);
                    print(s);

                    hospAddressCont.text = hospAddress[s];
                    FocusScope.of(context).unfocus();
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      decoration: InputDecoration(
                          labelText: 'Hospital name',
                          labelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.redAccent,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.redAccent, width: 2.5))),
                      controller: fieldTextEditingController,
                      onChanged: (value) {
                        hospName.text = value;
                        hospAddressCont.text = "Address unavailable";
                      },
                      focusNode: fieldFocusNode,
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  },
                ),
              ),
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
                      T1(content: "Preview", color: Colors.red),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
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
                                        T1(
                                            content: "Reason : ",
                                            color: Colors.white),
                                        T1(
                                            content: reasonForRequest.text
                                                .toString(),
                                            color: Colors.white),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        T1(
                                            content: "Patient Name : ",
                                            color: Colors.white),
                                        T1(
                                            content:
                                                patientName.text.toString(),
                                            color: Colors.white),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        T1(
                                            content: "Age : ",
                                            color: Colors.white),
                                        T1(
                                            content: patientAge.text.toString(),
                                            color: Colors.white),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        T1(
                                            content: "Hospital Name : ",
                                            color: Colors.white),
                                        Expanded(
                                          child: T1(
                                              content: hospName.text.toString(),
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        T1(
                                            content: "Hospital Address : ",
                                            color: Colors.white),
                                        Expanded(
                                          child: T1(
                                              content: hospAddressCont.text
                                                  .toString(),
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // urgent switch
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    T1(
                                        content: "Urgent : ",
                                        color: Colors.white),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeTrackColor: Colors.red[100],
                                      activeColor: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                "Hospital Address":
                                    hospAddressCont.text.toString(),
                                "BloodGroup": bloodGroup.text.toString(),
                                "Reason": reasonForRequest.text.toString(),
                                "phone": currentUser?.phoneNumber
                                    .toString()
                                    .substring(3),
                                "isUrgent": isSwitched,
                                "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: T1(
                                content: "Request placed",
                                color: Colors.redAccent,
                              )));
                              patientAge.clear();
                              patientName.clear();
                              hospName.clear();
                              hospAddressCont.clear();
                              bloodGroup.clear();
                              reasonForRequest.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(milliseconds: 300),
                                      margin:
                                          EdgeInsets.fromLTRB(20, 0, 20, 350),
                                      content: T1(
                                        content: "Please fill all details",
                                        color: Colors.redAccent,
                                      )));
                            }
                          },
                          child: Center(
                              child:
                                  T1(content: "Request", color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
