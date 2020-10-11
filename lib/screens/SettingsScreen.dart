import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;
  ReusableWidgets _reusableWidgets;

  @override
  Widget build(BuildContext context) {
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);

    return Scaffold(
      appBar: _reusableWidgets.getNormalAppBar(),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Inhalation
                Card(
                    //color: Colors.red,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.all(10),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Inhalation",
                              style: TextStyle(fontSize: 22),
                            ),
                            Divider(
                              color: Colors.black54,
                              thickness: 1,
                            ),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Morgens",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Text("2x Flutiform"),
                                    ],
                                  ),
                                )),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mittags",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Text("-"),
                                    ],
                                  ),
                                )),
                            Card(
                                //color: Colors.blue,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Abends",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Text("2x Flutiform"),
                                    ],
                                  ),
                                )),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Nachts",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Text("-"),
                                    ],
                                  ),
                                )),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sport und Notfall",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Text("1x Duovent"),
                                    ],
                                  ),
                                )),
                          ],
                        ))),
                Card(
                    //color: Colors.red,
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.all(10),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Erinnerungen",
                              style: TextStyle(fontSize: 22),
                            ),
                            Divider(
                              color: Colors.black54,
                              thickness: 1,
                            ),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Allergien",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Pollen-Esche"),
                                          Switch(
                                            value: true,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Pollen-Birke"),
                                          Switch(
                                            value: true,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Pollen-Buche"),
                                          Switch(
                                            value: true,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sonstige",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Divider(
                                        color: Colors.black54,
                                        thickness: 0.5,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Staub wischen"),
                                          Switch(
                                            value: true,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Bettwäsche waschen"),
                                          Switch(
                                            value: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ))),
                Card(
                  //color: Colors.red,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: Text("Export der Statistik"),
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
  }
}
