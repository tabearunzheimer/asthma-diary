import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  int _selectedIndex = 2;
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
