// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nolar/screens/LOGIN.dart';
import 'package:nolar/screens/allReq.dart';
import 'package:nolar/screens/home.dart';
import 'package:nolar/screens/otpval.dart';
import 'package:nolar/screens/register.dart';
import 'package:nolar/screens/request.dart';
import 'package:nolar/screens/splash.dart';

import 'firebase_options.dart';
Future<void> back(RemoteMessage message)async{
print("${message.data}");


}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(back);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    requestPermission();

  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   print("User has authorised");
    // } else if (settings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   print("User has provisional");
    // } else {
    //   print("User has declined or has not accepted permission");
    // }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nolar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: "/splash",
      routes: {
        '/splash': (context) => const Splash(),
        '/': (context) => const Login(),
        '/otpVal': (context) => const OtpVal(),
        '/home': (context) => const Home(),
        '/request': (context) => const Request(),
        '/allrequest': (context) => const AllReq(),
        '/register': (context) => const Register(),
      },
    );
  }
}
