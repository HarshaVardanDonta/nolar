// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? dropValue = dropItems.first;
  String selectedBlood = dropItems.first;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                T1(content: "Register as a Donor", color: Colors.redAccent),
                SizedBox(height: 20),
                RegisterTexxtField(
                  content: "Name",
                  controller: nameController,
                ),
                RegisterTexxtField(
                  content: "Age",
                  controller: ageController,
                ),
                RegisterTexxtField(
                  content: "Occupation",
                  controller: occupationController,
                ),
                RegisterTexxtField(
                  content: "Address",
                  controller: addressController,
                ),
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if(
                      nameController!= null &&
                      ageController!=null &&
                      occupationController!=null &&
                      addressController!=null &&
                      selectedBlood != "Select Blood Group"
                      ){
                        await FirebaseFirestore.instance
                            .collection("registration")
                            .doc("${currentUser?.phoneNumber}")
                            .set({
                          "UserName": nameController.text.toString(),
                          "Age": ageController.text.toString(),
                          "Occupation": occupationController.text.toString(),
                          "Address": addressController.text.toString(),
                          "BloodGroup": selectedBlood,
                          "phone":currentUser?.phoneNumber.toString().substring(3),
                        }, SetOptions(merge: true));
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Thank You'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        "Thank you for registering as a donor, we appreciate it,"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                      }
                      else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: T1(
                              content: "Please provide all details",
                              color: Colors.redAccent,
                            )));
                      }
                      setState(() {
                        Home.dispName = nameController.text.toString();
                      });

                      nameController.clear();
                      ageController.clear();
                      occupationController.clear();
                      addressController.clear();
                      selectedBlood = dropItems.first;


                    },
                    child: T1(content: "Submit", color: Colors.red)),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
