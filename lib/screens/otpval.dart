import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nolar/w.dart';

import 'LOGIN.dart';

class OtpVal extends StatefulWidget {
  const OtpVal({Key? key}) : super(key: key);

  @override
  State<OtpVal> createState() => _OtpValState();
}

class _OtpValState extends State<OtpVal> {
  @override
  Widget build(BuildContext context) {
    TextEditingController otp = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xffE93838),
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/ValidateBlob.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/logo3.png"),
                      T1(content: "Validate OTP", color: Color(0xffFF3434)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextField(
                      maxLength: 6,
                      controller: otp,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff262626),
                        hintText: "OTP",
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
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            PhoneAuthCredential credentials =
                                PhoneAuthProvider.credential(
                                    verificationId: Login.verify,
                                    smsCode: otp.text.toString());
                            await FirebaseAuth.instance
                                .signInWithCredential(credentials);
                            // print("sign in success");

                            Navigator.pushReplacementNamed(context, '/home');
                          } catch (e) {
                            print(e.toString());
                            print(otp.toString());
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: T1(
                              content: "wrong otp",
                              color: Colors.redAccent,
                            )));
                          }
                        },
                        child: Text("validate otp and login")),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
