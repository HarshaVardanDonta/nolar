import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nolar/screens/infoUpdate.dart';
import 'package:nolar/screens/register.dart';
import 'package:nolar/screens/request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../w.dart';
import 'package:image_cropper/image_cropper.dart';

import 'dash,dart.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String? dispName = "";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var controller = PageController(initialPage: 1);
  User? currentUser = FirebaseAuth.instance.currentUser;

  int selectedPage = 1;
  File? file;
  @override
  Widget build(BuildContext context) {
    String? picUrl = currentUser?.photoURL.toString();
    Home.dispName = "";

    currentUser?.displayName != null
        ? Home.dispName = currentUser?.displayName
        : Home.dispName = currentUser?.phoneNumber;
    FirebaseFirestore db = FirebaseFirestore.instance;

    refresh() {
      setState(() {
        print("set state called");
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: (currentUser?.displayName != null &&
                currentUser?.phoneNumber != null)
            ? AppBar(
                toolbarHeight: 60,
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                elevation: 0,
                title: SizedBox(
                    height: 20, child: Image.asset("assets/logo3.png")),
                actions: [
                  selectedPage != 0
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              controller.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: Icon(
                                Icons.account_circle_sharp,
                                size: 25,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 20,
                              child: Icon(
                                Icons.settings,
                                size: 25,
                              ),
                            ),
                          ),
                        )
                ],
              )
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
        drawer: Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(10),
              // padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 490,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.red,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(picUrl!),
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.center,
                              child: T1(
                                  content: "${currentUser?.displayName}",
                                  color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ),
                  DrawerButton(
                      content: 'Register',
                      fun: () {
                        Navigator.pushNamed(context, "/register");
                      }),
                  DrawerButton(
                    content: "About US",
                    fun: () {},
                  ),
                  DrawerButton(
                    content: "Our Team",
                    fun: () {},
                  ),
                  DrawerButton(
                    content: "Contact US",
                    fun: () async {
                      var url =
                          "https://api.whatsapp.com/send/?phone=+919391774548&text=Hello";
                      await launch(url);
                    },
                  ),
                  DrawerButton(
                    content: "Donate",
                    fun: () {},
                  ),
                  DrawerButton(
                    content: "Logout",
                    fun: () async {
                      await FirebaseAuth.instance.signOut();
                      // Navigator.pop(context);
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        body: (currentUser?.displayName != null &&
                currentUser?.phoneNumber != null)
            ? SafeArea(
                child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
                children: [
                  //profile
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              picUrl,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                return child;
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                          Positioned(
                            left: 100,
                            top: 100,
                            child: GestureDetector(
                              //edit display image
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                final image = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 30);
                                final path = image?.path;
                                setState(() {
                                  file = File(path!);
                                });

                                final storageRef = FirebaseStorage.instance
                                    .ref()
                                    .child(
                                        "profilePics/${currentUser?.phoneNumber}");
                                await storageRef.putFile(file!);
                                final imageUrl =
                                    await storageRef.getDownloadURL();
                                await currentUser?.updatePhotoURL(imageUrl);
                                // await currentUser?.updatePhotoURL();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: T1(
                                          content: "Image update success",
                                          color: Colors.redAccent,
                                        )));
                                setState(() {});
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(
                                    Icons.edit,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        T1(
                            content: "${currentUser?.displayName}",
                            color: Colors.redAccent),
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileButton(content: "Manage Account", icon: Icons.person, tap: () {  },),
                              ProfileButton(content: "Your Donations", icon: Icons.list, tap: () {  },),
                              ProfileButton(content: "Certificates", icon: Icons.newspaper_outlined, tap: () {  },),
                              ProfileButton(content: "Settings", icon: Icons.settings, tap: () {  },),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dash(),
                  //messages
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("chatRooms")
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
                                        if (snapshot.data!.docs[index]
                                                    ['numbers'][0] ==
                                                currentUser?.phoneNumber
                                                    .toString() ||
                                            snapshot.data!.docs[index]
                                                    ['numbers'][1] ==
                                                currentUser?.phoneNumber
                                                    .toString()) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                            grpId: snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['roomID']
                                                                .toString(),
                                                            to: (snapshot.data!.docs[index]
                                                                            [
                                                                            'numbers']
                                                                        [0] ==
                                                                    currentUser
                                                                        ?.phoneNumber)
                                                                ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                                : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.red[100],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Row(
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
                                                  T1(
                                                      content: (snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      'numbers']
                                                                  [0] ==
                                                              currentUser
                                                                  ?.phoneNumber)
                                                          ? "${snapshot.data!.docs[index]['numbers'][1]}"
                                                          : "${snapshot.data!.docs[index]['numbers'][0]}",
                                                      color: Colors.black),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  //  show registered users
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          T1(content: "Registered Donors", color: Colors.black),
                          FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("registration")
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final List<DocumentSnapshot> documents =
                                      snapshot.data!.docs;
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        200,
                                    child: ListView(
                                        children: documents
                                            .map((doc) => Card(
                                                  child: doc ==
                                                          ConnectionState
                                                              .waiting
                                                      ? CircularProgressIndicator()
                                                      : ListTile(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 0.0,
                                                                  right: 0.0,
                                                                  top: 0,
                                                                  bottom: 0),
                                                          leading: CircleAvatar(
                                                            radius: 25,
                                                            backgroundImage: doc ==
                                                                    ConnectionState
                                                                        .waiting
                                                                ? NetworkImage(
                                                                    "https://via.placeholder.com/150x150.png?text=user")
                                                                : NetworkImage(
                                                                    "https://firebasestorage.googleapis.com/v0/b/nolar-plus.appspot.com/o/profilePics%2F%2B91${doc['phone']}?alt=media&token=15ccf0f7-514a-43fa-821e-310c09cfc826"),
                                                          ),
                                                          title: Text(
                                                              doc['UserName']),
                                                          subtitle: Text(doc[
                                                              'BloodGroup']),
                                                        ),
                                                ))
                                            .toList()),
                                  );
                                }
                                return CircularProgressIndicator();
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
            //if username and disp name is not updated
            : InfoUpdate(
                notifyParent: refresh,
              ),
        bottomNavigationBar: (currentUser?.displayName != null &&
                currentUser?.phoneNumber != null)
            ? Container(
                margin: EdgeInsets.all(9),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff201D1D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //home
                    IconButton(
                        onPressed: () {
                          controller.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        icon: Icon(
                          Icons.home_filled,
                          color: selectedPage == 1 ? Colors.red : Colors.white,
                          size: 30,
                        )),

                    //  notifications
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: selectedPage == 2 ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.list,
                        color: selectedPage == 3 ? Colors.red : Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        controller.animateToPage(3,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                    ),
                  ],
                ),
              )
            : SizedBox(height: 10, child: Container()));
  }
}
