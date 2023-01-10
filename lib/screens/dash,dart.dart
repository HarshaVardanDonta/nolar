import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nolar/encrypt.dart';
import 'package:nolar/w.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  int currentNotificationCard = 0;

  @override
  Widget build(BuildContext context) {
    String? phNumber = currentUser?.phoneNumber;
    var listRooms = [];

    return SafeArea(
        child: Column(
      children: [
        StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection("request")
                .orderBy('timeStamp', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatRooms")
                        .snapshots(),
                    builder: (context, snapChat) {
                      //get all existing rooms with numbers
                      for (int i = 0; i < snapChat.data!.docs.length; i++) {
                        listRooms.add([
                          snapChat.data!.docs[i]['numbers'][0],
                          snapChat.data!.docs[i]['numbers'][1],
                          snapChat.data!.docs[i]['roomID']
                        ]);
                      }
                      return Column(
                        children: [
                          Container(
                            height: 220,
                            child: PageView.builder(
                                onPageChanged: (index) {
                                  setState(() {
                                    currentNotificationCard = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length >= 3
                                    ? 4
                                    : snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  if (index == 3) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/allrequest");
                                          },
                                          child: T2(
                                              content: "See All >",
                                              color: Colors.redAccent)),
                                    );
                                  }
                                  return NotificationCard(
                                    patientName: snapshot.data!.docs[index]
                                        ['Patient Name'],
                                    hospName:
                                        "${snapshot.data!.docs[index]['Hospital Name']} - ${snapshot.data!.docs[index]['Hospital Address']} ",
                                    reason: snapshot.data!.docs[index]
                                        ['Reason'],
                                    bloodGroup: snapshot.data!.docs[index]
                                        ['BloodGroup'],
                                    tap: () async {
                                      if ("+91${snapshot.data!.docs[index]['phone']}" ==
                                          currentUser?.phoneNumber.toString()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                margin: EdgeInsets.only(
                                                    bottom: 300,
                                                    left: 20,
                                                    right: 20),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                duration:
                                                    Duration(milliseconds: 300),
                                                content: T1(
                                                  content: "Your request",
                                                  color: Colors.redAccent,
                                                )));
                                      } else {
                                        late String gID;
                                        for (int i = 0;
                                            i <= snapChat.data!.docs.length;
                                            i++) {
                                          bool roomExiste = (listRooms[i][0] ==
                                                      "${currentUser?.phoneNumber}" &&
                                                  listRooms[i][1] ==
                                                      "+91${snapshot.data!.docs[index]['phone']}") ||
                                              ((listRooms[i][1] ==
                                                      "${currentUser?.phoneNumber}" &&
                                                  listRooms[i][0] ==
                                                      "+91${snapshot.data!.docs[index]['phone']}"));
                                          // print(roomExiste);
                                          if (roomExiste) {
                                            // print("room already exists");
                                            gID = listRooms[i][2].toString();
                                            // print(gID);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    margin: EdgeInsets.only(
                                                        bottom: 400,
                                                        left: 20,
                                                        right: 20),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    content: T1(
                                                      content:
                                                          "Chat already exists",
                                                      color: Colors.redAccent,
                                                    )));
                                            break;
                                          } else {
                                            // print("does not");
                                            gID = await EncryptData.encryptAES(
                                                "${currentUser?.phoneNumber}+91${snapshot.data!.docs[index]['phone']}");
                                          }
                                        }

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      grpId: gID,
                                                      to: "+91${snapshot.data!.docs[index]['phone']}",
                                                    )));
                                      }
                                    },
                                    share: () async {
                                      // var url =
                                      //     "https://wa.me/?text=${snapshot.data!.docs[index]['Patient Name']} needs blood, admitted at ${snapshot.data!.docs[index]['Hospital Name']}";
                                      // await launch(url);
                                      var bytes = await rootBundle
                                          .load('assets/Donate.png');
                                      final list = bytes.buffer.asUint8List();
                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final file = await File(
                                              '${tempDir.path}/Donate.png')
                                          .create();
                                      file.writeAsBytesSync(list);
                                      await Share.shareFiles(['${file.path}'],
                                          text:
                                              "${snapshot.data!.docs[index]['Patient Name']} requires blood at ${snapshot.data!.docs[index]['Hospital Name']} - ${snapshot.data!.docs[index]['Hospital Address']}",
                                          subject: "Nolar");
                                    },
                                    isUrgent: snapshot.data!.docs[index]
                                        ['isUrgent'],
                                  );
                                }),
                          ),
                          Container(
                            height: 5,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length >= 3
                                    ? 4
                                    : snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  //pill
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    width: (currentNotificationCard == index)
                                        ? 10
                                        : 5,
                                    decoration: BoxDecoration(
                                      color: (currentNotificationCard == index)
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    });
              }
            }),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/request");
            },
            child: T1(content: "Request Blood", color: Colors.red)),
      ],
    ));
  }
}
