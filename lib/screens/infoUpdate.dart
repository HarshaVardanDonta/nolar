import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../w.dart';
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


class InfoUpdate extends StatefulWidget {
  final Function() notifyParent;
  InfoUpdate({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<InfoUpdate> createState() => _InfoUpdateState();
}

class _InfoUpdateState extends State<InfoUpdate> {
  TextEditingController dispNameUpdate = TextEditingController();
  TextEditingController ageUpdate = TextEditingController();
  TextEditingController phoneUpdate = TextEditingController();
  TextEditingController otp = TextEditingController();
  String verify = "";
  bool otpSent = false;
  String selectedBlood = dropItems.first;

  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('registration')
          .doc()
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              T1(content: "Update Info", color: Colors.red),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: dispNameUpdate,
                  decoration: InputDecoration(

                      hintText: "Name",
                      hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.redAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(16),
                      )),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextField(
              //     controller: ageUpdate,
              //     keyboardType: TextInputType.phone,
              //     decoration: InputDecoration(
              //         hintText: "Age",
              //         hintStyle: GoogleFonts.poppins(
              //           textStyle: TextStyle(color: Colors.redAccent),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.red, width: 1.5),
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.red, width: 1.5),
              //           borderRadius: BorderRadius.circular(16),
              //         )),
              //   ),
              // ),
              PopupMenuButton(
                tooltip: "Select blood type",
                offset: Offset(1, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onSelected: (index) {
                  setState(() {
                    selectedBlood = dropItems[index];
                  });
                },
                //drop down
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.redAccent, width: 1.5)),
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
              SizedBox(height: 20),
              (currentUser?.phoneNumber == null)
                  ? TextField(
                      controller: phoneUpdate,
                      decoration: InputDecoration(

                          hintText: "Phone number",
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(16),
                          )),
                    )
                  : Container(),
              otpSent
                  ? SizedBox(
                      height: 100,
                      child: Pinput(
                        keyboardType: TextInputType.phone,
                        controller: otp,
                        length: 6,
                        enabled: true,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        defaultPinTheme: PinTheme(
                            height: 50,
                            width: 50,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                            decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(16))),
                        submittedPinTheme: PinTheme(
                            height: 50,
                            width: 50,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                            decoration: BoxDecoration(
                                color: Colors.red[300],
                                border: Border.all(
                                    color: Colors.redAccent, width: 1),
                                borderRadius: BorderRadius.circular(16))),
                        focusedPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                            decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(16))),
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
              otpSent
                  ? TextButton(
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credentials =
                              PhoneAuthProvider.credential(
                                  verificationId: verify,
                                  smsCode: otp.text.toString());
                          await currentUser?.linkWithCredential(credentials);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: T1(
                            content: "Link Success",
                            color: Colors.redAccent,
                          )));
                          // await Navigator.pushReplacementNamed(context, '/home');

                          await currentUser?.updateDisplayName(
                              dispNameUpdate.text.toString());
                          widget.notifyParent();
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: T1(
                            content: "number already in use",
                            color: Colors.redAccent,
                          )));
                        }
                      },
                      child: T1(content: "Verify otp", color: Colors.red))
                  : TextButton(
                      onPressed: () async {
                        //update phone number
                        if (currentUser?.phoneNumber == null) {
                          currentUser?.updateDisplayName(
                              dispNameUpdate.text.toString());

                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: "+91${phoneUpdate.text.toString()}",
                            timeout: const Duration(minutes: 2),
                            verificationCompleted: (credential) async {
                              // either this occurs or the user needs to manually enter the SMS code
                            },
                            codeSent: (verificationId,
                                [forceResendingToken]) async {
                              String smsCode;
                              verify = verificationId;
                              setState(() {
                                otpSent = true;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: T1(
                                content: "Code sent",
                                color: Colors.redAccent,
                              )));
                              // get the SMS code from the user somehow (probably using a text field)
                            },
                            verificationFailed: (FirebaseAuthException error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: T1(
                                content: "Phone verification failed",
                                color: Colors.redAccent,
                              )));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        }
                        if (currentUser?.displayName == null) {
                          await currentUser?.updateDisplayName(
                              dispNameUpdate.text.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: T1(
                            content: "Name updated",
                            color: Colors.redAccent,
                          )));
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                        widget.notifyParent();
                      },
                      child: T1(content: "Update", color: Colors.red)),
            ],
          ),
        );
      },
    );
  }
}
