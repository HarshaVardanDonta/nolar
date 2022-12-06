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
    print(picUrl);
    Home.dispName = "";

    currentUser?.displayName != null
        ? Home.dispName = currentUser?.displayName
        : Home.dispName = currentUser?.phoneNumber;
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(currentUser?.displayName);
    print(currentUser?.providerData);
    print(currentUser?.photoURL);

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
                toolbarHeight: 70,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 0,
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
              height: 450,
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
                  SizedBox(height: 20),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          Divider(thickness: 1),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              T1(content: "Name: ", color: Colors.redAccent),
                              SizedBox(
                                width: 250,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: T1(
                                      content: "${currentUser?.displayName}",
                                      color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              T1(content: "Phone: ", color: Colors.redAccent),
                              T1(
                                  content: "${currentUser?.phoneNumber}",
                                  color: Colors.redAccent),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              T1(content: "Email: ", color: Colors.redAccent),
                              SizedBox(
                                width: 300,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: T1(
                                      content: "${currentUser?.email}",
                                      color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(thickness: 1),
                          //acheivments
                          T1(content: "Acheivements", color: Colors.redAccent),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            margin: EdgeInsets.all(10),
                            height: 150,
                            child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.purple,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.purple
                                  ],
                                  stops: [
                                    0.0,
                                    0.02,
                                    0.98,
                                    1.0
                                  ], // 10% purple, 80% transparent, 10% purple
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 40),
                                  itemBuilder: (context, index) {
                                    return CircleAvatar();
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Dash(),
                  //register as a donor
                  Register(),
                  // request blood
                  Request(),
                  //  Notifications
                  //TODO: implement notifications
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        T1(content: "Messages", color: Colors.black),
                        CustomMessage(),
                        CustomMessage(),
                        CustomMessage(),
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
                                        250,
                                    child: ListView(
                                        children: documents
                                            .map((doc) => Card(
                                                  child: doc ==
                                                          ConnectionState
                                                              .waiting
                                                      ? CircularProgressIndicator()
                                                      : ListTile(
                                                          leading:
                                                              // Image.network(
                                                              //   "https://firebasestorage.googleapis.com/v0/b/nolar-plus.appspot.com/o/profilePics%2F%2B91${doc['phone']}?alt=media&token=15ccf0f7-514a-43fa-821e-310c09cfc826",
                                                              //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded){
                                                              //   return child;
                                                              // },
                                                              //   loadingBuilder: (context, child, loadingProgress){
                                                              //     if(loadingProgress == null){
                                                              //       return child;
                                                              //     }
                                                              //     else{
                                                              //       return Center(child: CircularProgressIndicator());
                                                              //     }
                                                              //   },
                                                              // ),
                                                              CircleAvatar(
                                                            radius: 50,
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
                          color: Colors.red,
                          size: 30,
                        )),
                    //Dashboard
                    IconButton(
                        onPressed: () {
                          controller.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        icon: Icon(
                          Icons.app_registration,
                          color: Colors.red,
                          size: 30,
                        )),
                    //request blood
                    IconButton(
                      icon: Image.asset("assets/RequestBlood.png"),
                      onPressed: () {
                        controller.animateToPage(3,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                    ),
                    //  notifications
                    IconButton(
                      icon: Image.asset("assets/Notifications.png"),
                      onPressed: () {
                        controller.animateToPage(4,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                    ),
                    IconButton(
                      icon: Image.asset("assets/Notifications.png"),
                      onPressed: () {
                        controller.animateToPage(5,
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
