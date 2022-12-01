import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nolar/w.dart';
import 'package:pinput/pinput.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  String veri = "";
  bool otpsent = false;
  FocusNode _focus = FocusNode();
  @override
  User? currentUser = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    bool isAuthing = false;
    return Scaffold(
        backgroundColor: Color(0xffE93838),
        body: Stack(
          children: [
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/LoginBlob.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.hasData) {
                    return Home();
                  }
                  return SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset("assets/logo3.png"),
                              T1(content: "Login", color: Color(0xffFF3434)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            otpsent
                                ? SizedBox(
                                    height: 100,
                                    child: Pinput(
                                      keyboardType: TextInputType.phone,
                                      controller: otp,
                                      length: 6,
                                      enabled: true,
                                      androidSmsAutofillMethod:
                                          AndroidSmsAutofillMethod
                                              .smsRetrieverApi,
                                      defaultPinTheme: PinTheme(
                                          height: 50,
                                          width: 50,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.red[100],
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                      submittedPinTheme: PinTheme(
                                          height: 50,
                                          width: 50,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.red[300],
                                              border: Border.all(
                                                  color: Colors.redAccent,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                      focusedPinTheme: PinTheme(
                                          width: 60,
                                          height: 60,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                          decoration: BoxDecoration(
                                              color: Colors.red[200],
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                    ),
                                  )
                                : TextField(
                                    controller: phNumber,
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500)),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xff262626),
                                      hintText: "Mobile number",
                                      hintStyle: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.w500)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        // borderSide:
                                        //     BorderSide(color: Colors.redAccent, width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        // borderSide:
                                        //     BorderSide(color: Colors.redAccent, width: 2.5),
                                      ),
                                    ),
                                  ),
                            //validate otp
                            otpsent
                                ? ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        PhoneAuthCredential credentials =
                                            PhoneAuthProvider.credential(
                                                verificationId: Login.verify,
                                                smsCode: otp.text.toString());

                                        await FirebaseAuth.instance
                                            .signInWithCredential(credentials);

                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                        setState(() {
                                          otpsent = false;
                                        });
                                      } catch (e) {
                                        print(e.toString());
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: T1(
                                          content: e.toString(),
                                          color: Colors.redAccent,
                                        )));
                                      }
                                    },
                                    child: T1(
                                        content: "Validate OTP",
                                        color: Colors.white))

                                //get otp
                                : ElevatedButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance
                                          .verifyPhoneNumber(
                                              phoneNumber:
                                                  "+91${phNumber.text.toString()}",
                                              verificationCompleted:
                                                  (PhoneAuthCredential
                                                      credentials) async {
                                                await FirebaseAuth.instance
                                                    .signInWithCredential(
                                                        credentials);
                                                await Navigator
                                                    .pushReplacementNamed(
                                                        context, '/home');
                                              },
                                              verificationFailed:
                                                  (FirebaseAuthException e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: T1(
                                                  content:
                                                      "Verification Failed",
                                                  color: Colors.redAccent,
                                                )));
                                                phNumber.clear();
                                                if (e.code ==
                                                    'invalid-phone-number') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: T1(
                                                    content:
                                                        "Invalid PhoneNumber",
                                                    color: Colors.redAccent,
                                                  )));
                                                }
                                              },
                                              //executes after otp is sent
                                              codeSent: (String verificationId,
                                                  int?
                                                      forceResendingToken) async {
                                                veri = verificationId;
                                                Login.verify = veri;
                                                phNumber.clear();
                                                setState(() {
                                                  otpsent = true;
                                                });
                                              },
                                              codeAutoRetrievalTimeout:
                                                  (String verificationId) {});
                                    },
                                    child: Text("Get OTP")),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Already have an account?",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        SizedBox(height: 1)
                      ],
                    ),
                  ));
                })
          ],
        ));
  }
}
