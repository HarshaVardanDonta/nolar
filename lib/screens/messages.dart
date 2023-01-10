import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../w.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  User? currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    String currentUs = currentUser!.displayName.toString();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatRooms")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator());
                    } else {
                      return Flexible(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child:
                                    CircularProgressIndicator());
                              }
                              try {
                                if (snapshot.data!.docs[index]
                                ['numbers'][0] ==
                                    currentUser?.phoneNumber
                                        .toString() ||
                                    snapshot.data!.docs[index]
                                    ['numbers'][1] ==
                                        currentUser?.phoneNumber
                                            .toString()) {
                                  String toNumber = (snapshot
                                      .data!.docs[index]
                                  ['numbers'][0] ==
                                      currentUser?.phoneNumber)
                                      ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                      : "${snapshot.data!.docs[index]['numbers'][0]}";

                                  return InkWell(
                                      onTap: () async {
                                        setState(() {});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    ChatScreen(
                                                      grpId: snapshot
                                                          .data!
                                                          .docs[
                                                      index]
                                                      [
                                                      'roomID']
                                                          .toString(),
                                                      to: (snapshot.data!.docs[index]['numbers'][0] ==
                                                          currentUser?.phoneNumber)
                                                          ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                          : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                    ))).then(
                                                (value) async {
                                              print("chat exited");
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection('chatRooms')
                                                  .doc(snapshot
                                                  .data!
                                                  .docs[index]
                                              ['roomID']
                                                  .toString())
                                                  .update({
                                                "${currentUser?.phoneNumber} in chat":
                                                false,
                                              });
                                            });
                                        await FirebaseFirestore
                                            .instance
                                            .collection('chatRooms')
                                            .doc(snapshot.data!
                                            .docs[index]['roomID']
                                            .toString())
                                            .update({
                                          "${currentUser?.phoneNumber}":
                                          false,
                                          "noOfMessages to ${currentUser?.phoneNumber}":
                                          0,
                                          "${currentUser?.phoneNumber} in chat":
                                          true,
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 0, 20, 0),
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (snapshot.data!
                                              .docs[index]
                                          [
                                          "${currentUs}"] ==
                                              true)
                                              ? Colors.red[100]
                                              : Colors.grey[300],
                                          borderRadius:
                                          BorderRadius.circular(
                                              50),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding:
                                              EdgeInsets.all(8),
                                              decoration:
                                              BoxDecoration(),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                          width: 80),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          T1(
                                                              content: (snapshot.data!.docs[index]['numbers'][0] == currentUser?.phoneNumber)
                                                                  ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                                  : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                              color: Colors
                                                                  .black),
                                                          SizedBox(
                                                            width:
                                                            200,
                                                            child:
                                                            Text(
                                                              "${snapshot.data!.docs[index]['lastMessage']}",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: GoogleFonts.poppins(
                                                                  textStyle: TextStyle(
                                                                      fontSize: 15,
                                                                      color: Colors.black45,
                                                                      letterSpacing: 1,
                                                                      fontWeight: FontWeight.w300)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  if (snapshot.data!.docs[
                                                  index]
                                                  [
                                                  currentUs] ==
                                                      true &&
                                                      snapshot.data!.docs[
                                                      index]
                                                      [
                                                      'noOfMessages to ${currentUser?.phoneNumber}'] !=
                                                          0)
                                                    T1(
                                                        content:
                                                        "+${snapshot.data!.docs[index]['noOfMessages to ${currentUser?.phoneNumber}']}",
                                                        color: Colors
                                                            .red)
                                                ],
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: snapshot ==
                                                  ConnectionState
                                                      .waiting
                                                  ? NetworkImage(
                                                  "https://via.placeholder.com/150x150.png?text=user")
                                                  : NetworkImage(
                                                  "https://firebasestorage.googleapis.com/v0/b/nolar-plus.appspot.com/o/profilePics%2F%2B91${(snapshot.data!.docs[index]['numbers'][0] == currentUser?.phoneNumber) ? snapshot.data!.docs[index]['numbers'][1].toString().substring(3) : snapshot.data!.docs[index]['numbers'][0].toString().substring(3)}?alt=media&token=f99d3d0e-bc27-4cc3-862f-0d3c667fa6a6"),
                                            ),
                                          ],
                                        ),
                                      ));
                                } else {
                                  return Container();
                                }
                              } catch (e) {
                                print(e);
                                if (snapshot.data!.docs[index]
                                ['numbers'][0] ==
                                    currentUser?.phoneNumber
                                        .toString() ||
                                    snapshot.data!.docs[index]
                                    ['numbers'][1] ==
                                        currentUser?.phoneNumber
                                            .toString()) {
                                  String toNumber = (snapshot
                                      .data!.docs[index]
                                  ['numbers'][0] ==
                                      currentUser?.phoneNumber)
                                      ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                      : "${snapshot.data!.docs[index]['numbers'][0]}";

                                  return InkWell(
                                      onTap: () async {
                                        setState(() {});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    ChatScreen(
                                                      grpId: snapshot
                                                          .data!
                                                          .docs[
                                                      index]
                                                      [
                                                      'roomID']
                                                          .toString(),
                                                      to: (snapshot.data!.docs[index]['numbers'][0] ==
                                                          currentUser?.phoneNumber)
                                                          ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                          : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                    ))).then(
                                                (value) async {
                                              print("chat exited");
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection('chatRooms')
                                                  .doc(snapshot
                                                  .data!
                                                  .docs[index]
                                              ['roomID']
                                                  .toString())
                                                  .update({
                                                "${currentUser?.phoneNumber} in chat":
                                                false,
                                              });
                                            });
                                        await FirebaseFirestore
                                            .instance
                                            .collection('chatRooms')
                                            .doc(snapshot.data!
                                            .docs[index]['roomID']
                                            .toString())
                                            .update({
                                          "${currentUser?.phoneNumber}":
                                          false,
                                          "noOfMessages to ${currentUser?.phoneNumber}":
                                          0,
                                          "${currentUser?.phoneNumber} in chat":
                                          true,
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red[200],
                                          borderRadius:
                                          BorderRadius.circular(
                                              50),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: snapshot ==
                                                      ConnectionState
                                                          .waiting
                                                      ? NetworkImage(
                                                      "https://via.placeholder.com/150x150.png?text=user")
                                                      : NetworkImage(
                                                      "https://firebasestorage.googleapis.com/v0/b/nolar-plus.appspot.com/o/profilePics%2F%2B91${(snapshot.data!.docs[index]['numbers'][0] == currentUser?.phoneNumber) ? snapshot.data!.docs[index]['numbers'][1].toString().substring(3) : snapshot.data!.docs[index]['numbers'][0].toString().substring(3)}?alt=media&token=f99d3d0e-bc27-4cc3-862f-0d3c667fa6a6"),
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    T1(
                                                        content: (snapshot.data!.docs[index]['numbers']
                                                        [
                                                        0] ==
                                                            currentUser
                                                                ?.phoneNumber)
                                                            ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                            : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                        color: Colors
                                                            .black),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        "${snapshot.data!.docs[index]['lastMessage']}",
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.poppins(
                                                            textStyle: TextStyle(
                                                                fontSize:
                                                                15,
                                                                color: Colors
                                                                    .black45,
                                                                letterSpacing:
                                                                1,
                                                                fontWeight:
                                                                FontWeight.w300)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                } else {
                                  return Container();
                                }
                              }
                            }),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
