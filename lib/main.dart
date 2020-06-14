import 'package:flutter/material.dart';
import 'package:the_good_bot/screens/initial_screen.dart';
import 'package:the_good_bot/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/splash",
      routes: {        
        "/": (context) => InitialScreen(),
        "/splash": (context) => SplashScreen(),
      },
    );
  }
}