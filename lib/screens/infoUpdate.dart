import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../w.dart';

class InfoUpdate extends StatefulWidget {
  final Function() notifyParent;
  InfoUpdate({Key? key, required this.notifyParent}) : super(key: key);

  @override
  State<InfoUpdate> createState() => _InfoUpdateState();
}

class _InfoUpdateState extends State<InfoUpdate> {
  TextEditingController dispNameUpdate = TextEditingController();
  TextEditingController phoneUpdate = TextEditingController();
  TextEditingController otp = TextEditingController();
  String verify = "";
  bool otpSent = false;

  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            T1(content: "Update Info", color: Colors.red),
            SizedBox(height: 20),
            TextField(
              controller: dispNameUpdate,
              decoration: InputDecoration(
                  fillColor: Colors.red[100],
                  filled: true,
                  hintText: "Name",
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.redAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
            SizedBox(height: 20),
            (currentUser?.phoneNumber == null)
                ? TextField(
                    controller: phoneUpdate,
                    decoration: InputDecoration(
                        fillColor: Colors.red[100],
                        filled: true,
                        hintText: "Phone number",
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(color: Colors.redAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
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
                              border:
                                  Border.all(color: Colors.redAccent, width: 1),
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

                        await currentUser?.updateDisplayName(dispNameUpdate.text.toString());
                        widget.notifyParent();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/home');
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
                        currentUser?.updateDisplayName(dispNameUpdate.text.toString());

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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: T1(
                              content: "Code sent",
                              color: Colors.redAccent,
                            )));
                            // get the SMS code from the user somehow (probably using a text field)
                          },
                          verificationFailed: (FirebaseAuthException error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: T1(
                              content: "Phone verification failed",
                              color: Colors.redAccent,
                            )));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      }
                      if (currentUser?.displayName == null){
                        await currentUser?.updateDisplayName(dispNameUpdate.text.toString());
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: T1(
                              content: "Name updated",
                              color: Colors.redAccent,
                            )));
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/home');
                      }
                      widget.notifyParent();
                    },
                    child: T1(content: "Update", color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
