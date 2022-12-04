import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nolar/w.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
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
  final _currentPageNotifier = ValueNotifier<int>(0);
  final pageCont = PageController();
  late Timer timer;
  @override
  User? currentUser = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    bool isAuthing = false;

    return Scaffold(
        backgroundColor: Color(0xffE93838),
        body: Stack(
          children: [
            //TODO:change the background in login page
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
                  return PageView(
                      controller: pageCont,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageNotifier.value = index;
                        });
                      },
                      pageSnapping: true,
                      children: [
                        InfoCard(
                          content: Column(
                            children: [
                              T1(content: "Donate blood", color: Colors.red)
                            ],
                          ),
                        ),
                        InfoCard(
                          content: Column(
                            children: [
                              T1(content: "Donate blood", color: Colors.red)
                            ],
                          ),
                        ),
                        InfoCard(
                          content: Column(
                            children: [
                              T1(content: "Donate blood", color: Colors.red)
                            ],
                          ),
                        ),
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                height: 200,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset("assets/logo3.png"),
                                    T1(
                                        content: "Login",
                                        color: Color(0xffFF3434)),
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
                                                        BorderRadius.circular(
                                                            16))),
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
                                                        BorderRadius.circular(
                                                            16))),
                                            focusedPinTheme: PinTheme(
                                                width: 60,
                                                height: 60,
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.red[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16))),
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
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              // borderSide:
                                              //     BorderSide(color: Colors.redAccent, width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                                      verificationId:
                                                          Login.verify,
                                                      smsCode:
                                                          otp.text.toString());

                                              await FirebaseAuth.instance
                                                  .signInWithCredential(
                                                      credentials);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: T1(
                                                    content: "Login success",
                                                    color: Colors.redAccent,
                                                  )));
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
                                                content: "wrong otp please try again",
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
                                                      await FirebaseAuth
                                                          .instance
                                                          .signInWithCredential(
                                                              credentials);
                                                      await Navigator
                                                          .pushReplacementNamed(
                                                              context, '/home');
                                                    },
                                                    verificationFailed:
                                                        (FirebaseAuthException
                                                            e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: T1(content:
                                                        "verification failed please try again",
                                                        color: Colors.redAccent,
                                                      )));
                                                      phNumber.clear();
                                                      if (e.code ==
                                                          'invalid-phone-number') {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                                    content: T1(
                                                          content:
                                                              "Invalid PhoneNumber",
                                                          color:
                                                              Colors.redAccent,
                                                        )));
                                                      }
                                                    },
                                                    //executes after otp is sent
                                                    codeSent: (String
                                                            verificationId,
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
                                                        (String
                                                            verificationId) {});
                                          },
                                          child: Text("Get OTP")),
                                ],
                              ),
                              Column(
                                children: [
                                  //g sign in
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.black),
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:30,
                                            child:
                                            Image.asset("assets/gIcon.png"),
                                          ),
                                          SizedBox(width: 10),
                                          T1(
                                              content: "Sign In with google",
                                              color: Colors.white)
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      if (GoogleSignIn().currentUser == null) {
                                        final GoogleSignInAccount? user =
                                            await GoogleSignIn().signIn();
                                        final GoogleSignInAuthentication gAuth =
                                            await user!.authentication;
                                        final AuthCredential cred =
                                            GoogleAuthProvider.credential(
                                                accessToken: gAuth.accessToken,
                                                idToken: gAuth.idToken);
                                        await FirebaseAuth.instance
                                            .signInWithCredential(cred);
                                        // await Navigator.pushReplacementNamed(
                                        //     context, '/home');
                                      }
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  //email sign in
                                  InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.black),
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.email,color: Colors.white,),
                                          SizedBox(width: 10),
                                          T1(
                                              content: "Sign In using email",
                                              color: Colors.white)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1)
                            ],
                          ),
                        )),
                      ]);
                }),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: CirclePageIndicator(
                  size: 10,
                  selectedSize: 13,
                  dotColor: Colors.red[100],
                  selectedDotColor: Colors.red[900],
                  currentPageNotifier: _currentPageNotifier,
                  itemCount: 4),
            ),
          ],
        ));
  }
}
