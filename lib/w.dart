// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T1 extends StatefulWidget {
  String content;
  Color color;

  T1({super.key, required this.content, required this.color});

  @override
  State<T1> createState() => _T1State();
}

class _T1State extends State<T1> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 19,
              color: widget.color,
              letterSpacing: 1,
              fontWeight: FontWeight.w500)),
    );
  }
}

class T2 extends StatefulWidget {
  String content;
  Color color;

  T2({super.key, required this.content, required this.color});

  @override
  _T2State createState() => _T2State();
}

class _T2State extends State<T2> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 15,
              color: widget.color,
              letterSpacing: 1,
              fontWeight: FontWeight.w500)),
    );
  }
}

class DrawerButton extends StatefulWidget {
  String content;
  dynamic fun;
  DrawerButton({super.key, required this.content, required this.fun});

  @override
  State<DrawerButton> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, elevation: 0),
        onPressed: widget.fun,
        child: T1(content: widget.content, color: Colors.red));
  }
}

class RegisterTexxtField extends StatefulWidget {
  String content;
  TextEditingController controller;
  RegisterTexxtField(
      {super.key, required this.content, required this.controller});

  @override
  State<RegisterTexxtField> createState() => _RegisterTexxtFieldState();
}

class _RegisterTexxtFieldState extends State<RegisterTexxtField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: false,
        controller: widget.controller,
        style: TextStyle(color: Colors.redAccent),
        decoration: InputDecoration(
            labelText: widget.content,
            labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.redAccent, width: 2.5))),
      ),
    );
  }
}

class RegisterTextField extends StatefulWidget {
  String content;
  TextEditingController controller;
  RegisterTextField({Key? key, required this.content, required this.controller})
      : super(key: key);

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            labelText: widget.content,
            labelStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.redAccent,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.redAccent, width: 2.5))),
      ),
    );
  }
}

class CustomMessage extends StatefulWidget {
  const CustomMessage({Key? key}) : super(key: key);

  @override
  State<CustomMessage> createState() => _CustomMessageState();
}

class _CustomMessageState extends State<CustomMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/MessageTemplate.png"),
            fit: BoxFit.fitWidth),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  dynamic content;
  InfoCard({Key? key, required this.content}) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(30, 150, 30, 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: widget.content,
    );
  }
}

class ChatScreen extends StatefulWidget {
  String grpId;
  String to;

  ChatScreen({Key? key, required this.grpId, required this.to})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msg = TextEditingController();
  final ScrollController _controller = ScrollController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        elevation: 0,
        foregroundColor: Colors.white,
        title: T1(content: widget.to, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.red[200],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .doc(widget.grpId)
                    .collection(widget.grpId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var listMessage = snapshot.data?.docs;
                    print(listMessage);
                    return ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) => BubbleChat(
                          content:
                              snapshot.data!.docs[index]['content'].toString(),
                          from:
                              snapshot.data!.docs[index]['idFrom'].toString()),
                    );
                  }
                },
              ),
            ),
          )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: msg,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.redAccent,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500)),
                  decoration: InputDecoration(
                    hintText: "start writing",
                    hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.redAccent,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500)),
                    contentPadding: EdgeInsets.all(8),
                    // enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(0),
                    //     borderSide:
                    //         BorderSide(color: Colors.redAccent, width: 1.5)),
                    // focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(0),
                    //     borderSide:
                    //         BorderSide(color: Colors.redAccent, width: 2.5)),
                  ),
                ),
              ),

              //send button
              IconButton(
                  onPressed: () async {
                    if (msg.text.toString().trim() != '') {
                      //write message
                      var documentReference = FirebaseFirestore.instance
                          .collection('messages')
                          .doc(widget.grpId)
                          .collection(widget.grpId)
                          .doc(
                              DateTime.now().millisecondsSinceEpoch.toString());

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        await transaction.set(
                          documentReference,
                          {
                            'idFrom': currentUser?.phoneNumber,
                            'idTo': widget.to,
                            'timestamp': DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            'content': msg.text.toString(),
                          },
                        );
                        msg.clear();
                      });

                      // register message
                      await FirebaseFirestore.instance
                          .collection("chatRooms")
                          .doc(widget.grpId)
                          .set({
                        "roomID": widget.grpId,
                        "numbers": FieldValue.arrayUnion([
                          currentUser?.phoneNumber.toString(),
                          widget.to.toString()
                        ])
                      }, SetOptions(merge: true));

                      _controller.animateTo(0.0,
                          duration: Duration(milliseconds: 900),
                          curve: Curves.easeOut);
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.red,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  String patientName;
  String hospName;
  String bloodGroup;
  String reason;
  NotificationCard(
      {Key? key,
      required this.patientName,
      required this.hospName,
      required this.reason,
      required this.bloodGroup})
      : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 250,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.red[100], borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              T2(content: "Patient Name :", color: Colors.white),
              T2(content: widget.patientName, color: Colors.red),
              T2(content: "Hospital :", color: Colors.white),
              T2(content: widget.hospName, color: Colors.red),
              T2(content: "Type :", color: Colors.white),
              T2(content: widget.bloodGroup, color: Colors.red),
              T2(content: widget.reason, color: Colors.red)
            ],
          )
        ],
      ),
    );
  }
}

class BubbleChat extends StatefulWidget {
  String content;
  String from;
  BubbleChat({Key? key, required this.content, required this.from})
      : super(key: key);

  @override
  State<BubbleChat> createState() => _BubbleChatState();
}

class _BubbleChatState extends State<BubbleChat> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (widget.from == currentUser?.phoneNumber)
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: (widget.from == currentUser?.phoneNumber)
                ? BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))
                : BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
        child: Flexible(child: Text( widget.content,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 19,
                  color: Colors.red,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500)),
        ),),
      ),
    );
  }
}
