import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {

  int _selectedIndex = 1;
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
