import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 4),(){
      Navigator.pushReplacementNamed(context, "/");
    });
    return Center(
        child: RiveAnimation.asset(
      "assets/splash.riv",
      fit: BoxFit.fill,
      controllers: [
        SimpleAnimation("Animation 1"),
      ],
    ));

  }
}
