import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableWidgets{
  BuildContext _context;
  int _selectedIndex;

  ReusableWidgets(BuildContext ctx, int index){
    _context = ctx;
    _selectedIndex = index;
  }

  Widget getNormalAppBar(){
    return new AppBar(
      title: Text("Asthma-Tagebuch", style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
    );
  }

  Widget getBottomNavigationBar(){
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Tagesansicht"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          title: Text("Einträge"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          title: Text("Statistiken"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text("Einstellungen"),
        ),
      ],
      selectedItemColor: Color.fromRGBO(0, 0, 200, 1),
      unselectedItemColor: Colors.black,
      showUnselectedLabels: false,
      onTap: onTapNavigation,
      currentIndex: _selectedIndex,
      //currentIndex: _selectedIndex,
    );
  }

  void onTapNavigation(int value) {
    //setState(() {
    if (_selectedIndex == value) {
      print("Aktueller Screen");
    } else {
      _selectedIndex = value;
      switch (value) {
        case 0:
          print("Change to Home Screen");
          Navigator.pushReplacementNamed(_context, '/home');
          break;
        case 1:
          print("Change to Diary Screen");
          //Navigator.pop(context);
          Navigator.pushReplacementNamed(_context, '/diary');
          break;
        case 2:
          print("Change to Statistics Screen");
          Navigator.pushReplacementNamed(_context, '/statistics');
          break;
        case 3:
          print("Change to Settings Screen");
          Navigator.pushReplacementNamed(_context, '/settings');
          break;
      }
    }
  }

}