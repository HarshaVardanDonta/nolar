// ignore_for_file: prefer_const_constructors, must_be_immutable

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
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 20,
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
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
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
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.redAccent, width: 2.5))),
      ),
    );
  }
}

class RegisterTextField extends StatefulWidget {
  String content;
  TextEditingController controller;
   RegisterTextField({Key? key, required this.content, required this.controller}) : super(key: key);

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
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
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
      margin: EdgeInsets.fromLTRB(0,10,0,10),
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

