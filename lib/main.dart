import 'package:flutter/material.dart';
import 'package:travelplanner/Pages/login.dart';
import 'package:travelplanner/Pages/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAV8ed1n73-dGIa7krpZ0eCOhv4J1Uu718",
          appId: "1:926709981503:web:249359d069915e01e2f38a",
          messagingSenderId: "926709981503",
          projectId: "genesis-82adf"));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      //home: TravelForm(),
      routes: {
        TravelForm.route: (context) => TravelForm(),
      },
    );
  }
}
