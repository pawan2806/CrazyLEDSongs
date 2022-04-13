
import 'package:crazy_led_songs/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './MainPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new ExampleApplication());
}

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
            fontFamily: 'Circular',
            primaryColor: Color(0xFF7579E7),
            accentColor:Color(0xFF7579E7),
            cursorColor: Color(0xFF7579E7),
            textSelectionHandleColor:Color(0xFF7579E7)),
      home: LandingPage()
        );
  }
}