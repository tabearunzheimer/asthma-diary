import 'package:asthma_tagebuch/screens/DiaryScreen.dart';
import 'package:asthma_tagebuch/screens/HomeScreen.dart';
import 'package:asthma_tagebuch/screens/SettingsScreen.dart';
import 'package:asthma_tagebuch/screens/StatisticsScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basis App',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Color.fromRGBO(0, 0, 200, 1),
        primaryColor: Colors.black,

        //fontFamily: 'Staatliches',
        primaryTextTheme: TextTheme(
            body1: TextStyle(color: Colors.black),
          button: TextStyle(color: Colors.black)
        ),

        scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 0.9),

        textSelectionColor: Color.fromRGBO(0, 0, 0, 1),
      ),
      initialRoute: '/',
      routes: {
        '/home' : (context) => HomeScreen(),
        '/diary' : (context) => DiaryScreen(),
        '/statistics' : (context) => StatisticsScreen(),
        '/settings' : (context) => SettingsScreen(),
      },
      home: HomeScreen(),
    );
  }
}
