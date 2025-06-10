import 'package:flutter/material.dart';
import 'package:myapp/homepage.dart'; // This will be the main repair form

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // The main entry point
      routes: {
        "/home": (context) => HomePage(),
        // Removed "/tablas" route as it's merged into /home logic now
      },
    );
  }
}