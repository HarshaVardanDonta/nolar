import 'package:flutter/material.dart';
import 'package:nolar/w.dart';

class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [T1(content: "Dashboard", color: Colors.red)],
    ));
  }
}
