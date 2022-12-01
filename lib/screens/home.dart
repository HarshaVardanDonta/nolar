import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nolar/screens/register.dart';
import 'package:nolar/screens/request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../w.dart';

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
    return Scaffold(
        appBar: AppBar(
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
        ),
        drawer: Drawer(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                T1(content: "Hi ${Home.dispName}", color: Colors.redAccent),
                DrawerButton(
                  content: "About US",
                  fun: () {},
                ),
                SizedBox(height: 20),
                DrawerButton(
                  content: "Our Team",
                  fun: () {},
                ),
                SizedBox(height: 20),
                DrawerButton(
                  content: "Contact US",
                  fun: () async {
                    var url =
                        "https://api.whatsapp.com/send/?phone=+919391774548&text=Hello";
                    await launch(url);
                  },
                ),
                SizedBox(height: 20),
                DrawerButton(
                  content: "Donate",
                  fun: () {},
                ),
                SizedBox(height: 20),
                DrawerButton(
                  content: "Logout",
                  fun: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                )
              ],
            ),
          )),
        ),
        body: SafeArea(
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
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(picUrl!),
                      ),
                      Positioned(
                        left: 100,
                        top: 100,
                        child: GestureDetector(
                          //edit display image
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final image = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 30);
                            final path = image?.path;
                            setState(() {
                              file = File(path!);
                            });

                            final storageRef = FirebaseStorage.instance
                                .ref()
                                .child(
                                    "profilePics/${currentUser?.phoneNumber}");
                            await storageRef.putFile(file!);
                            final imageUrl = await storageRef.getDownloadURL();
                            setState(() {
                              currentUser?.updatePhotoURL(imageUrl);
                            });
                            setState(() {});
                            setState(() {});
                            // await currentUser?.updatePhotoURL();
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
                        T1(
                            content: "${currentUser?.displayName}",
                            color: Colors.redAccent),
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
            //home
            Register(),
            // request blood
            Request(),
            //  Notifications
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
                              height: MediaQuery.of(context).size.height - 250,
                              child: ListView(
                                  children: documents
                                      .map((doc) => Card(
                                            child: ListTile(
                                              title: Text(doc['UserName']),
                                              subtitle: Text(doc['BloodGroup']),
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
        )),
        bottomNavigationBar: Container(
          child: Stack(
            children: [
              Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xff201D1D),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Dashboard
                      IconButton(
                          onPressed: () {
                            controller.animateToPage(1,
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
                          controller.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                      ),
                      //  notifications
                      IconButton(
                        icon: Image.asset("assets/Notifications.png"),
                        onPressed: () {
                          controller.animateToPage(3,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                      ),
                      IconButton(
                        icon: Image.asset("assets/Notifications.png"),
                        onPressed: () {
                          controller.animateToPage(4,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
