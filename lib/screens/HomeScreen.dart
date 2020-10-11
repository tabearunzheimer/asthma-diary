import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  ReusableWidgets _reusableWidgets;

  @override
  Widget build(BuildContext context) {
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);

    return Scaffold(
        appBar: _reusableWidgets.getNormalAppBar(),
        bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
  }


}
