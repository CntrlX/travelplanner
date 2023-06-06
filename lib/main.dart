import 'package:flutter/material.dart';
import 'package:travelplanner/Pages/login.dart';
import 'package:travelplanner/Pages/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
      home: const LoginPage(),
      //home: TravelForm(),
      routes: {
        TravelForm.route: (context) => const TravelForm(),
      },
    );
  }
}
