import 'package:covid19bd/constants.dart';
import 'package:covid19bd/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
       primaryColorDark: primaryColorDark,
          accentColor: colorAccent
      ),

      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


