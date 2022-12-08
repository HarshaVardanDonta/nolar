import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nolar/encrypt.dart';
import 'package:nolar/w.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    String? phNumber = currentUser?.phoneNumber;

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("request").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  // print(snapshot.data!.docs[0]['Age']);
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              EncryptData.encryptAES("${currentUser?.phoneNumber}+91${snapshot.data!.docs[index]['phone']}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            grpId:
                                            EncryptData.encryptAES("${currentUser?.phoneNumber}+91${snapshot.data!.docs[index]['phone']}").toString(),
                                            to: "+91${snapshot.data!.docs[index]['phone']}",
                                          )));
                            },
                            child: NotificationCard(
                              patientName: snapshot.data!.docs[index]
                                  ['Patient Name'],
                              hospName: snapshot.data!.docs[index]
                                  ['Hospital Name'],
                              reason: snapshot.data!.docs[index]['Reason'],
                              bloodGroup: snapshot.data!.docs[index]
                                  ['BloodGroup'],
                            ),
                          );
                        }),
                  );
                }
              }),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/request");
              },
              child: T1(content: "Request Blood", color: Colors.red)),
        ],
      ),
    ));
  }
}
