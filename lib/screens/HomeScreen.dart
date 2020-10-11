import 'package:asthma_tagebuch/helper/Diary.dart';
import 'package:asthma_tagebuch/helper/Inhalation.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:asthma_tagebuch/helper/date_helper.dart';
import 'package:asthma_tagebuch/helper/diary_database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Diary _d;
  bool _saveButtonOp;
  int _selectedIndex = 0;
  ReusableWidgets _reusableWidgets;
  List<Inhalation> _morning;
  List<Inhalation> _noon;
  List<Inhalation> _evening;
  List<Inhalation> _night;
  List<bool> _inhalationDone;
  List<String> _symptoms = [
    "Anstrengung beim Ausatmen",
    "Atemnot",
    "Brustschmerzen",
    "Engegefühl in der Brust",
    "hohe Herzfreuenz",
    "Husten",
    "Pfeifen"
  ];
  List<String> _surroundings = [
    "Allergische Reaktion",
    "Angst/ Panik",
    "Bettzeug waschen",
    "Krank",
    "Putzen",
    "Sport",
  ];
  DateTime _visibleDay;
  List<bool> ratingButtons = [true, false, false];

  final dbHelper = DiaryDatabaseHelper.instance;

  @override
  void initState() {
    _d = new Diary(0, null, null, null, null, null, "", "", 0, 0, 0, "");
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);
    _morning = new List<Inhalation>();
    _noon = new List<Inhalation>();
    _evening = new List<Inhalation>();
    _night = new List<Inhalation>();
    _inhalationDone = new List<bool>();
    _visibleDay = new DateTime.now();
    _saveButtonOp = false;
    createDayList();
    //dbHelper.insertList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _reusableWidgets.getNormalAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: previousDay,
                        ),
                        Text(_visibleDay.day.toString() +
                            ". " +
                            new DateHelper().getMonthName(_visibleDay.month) +
                            " " +
                            _visibleDay.year.toString()),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: nextDay,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildList(),
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSymptomsAndSurroundingsList(
                          "Aufgetretene Symptome", _symptoms),
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSymptomsAndSurroundingsList(
                          "Umstände des Tages", _surroundings),
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeadline("Eigene Notizen"),
                        getDivider(),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextField(
                            onTap: showSaveButton,
                            onEditingComplete: showSaveButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeadline("Gesamtbewertung des Tages"),
                        getDivider(),
                        ToggleButtons(
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 3,
                              child: Icon(Icons.thumb_up),
                              alignment: Alignment.center,
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 3,
                              child: Icon(Icons.thumbs_up_down),
                              alignment: Alignment.center,
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width - 40) / 3,
                              child: Icon(Icons.thumb_down),
                              alignment: Alignment.center,
                            ),
                          ],
                          isSelected: ratingButtons,
                          color: Colors.black,
                          selectedColor: Color.fromRGBO(0, 0, 200, 1),
                          onPressed: ratingButtonPressed,
                          fillColor: Colors.white,
                          borderColor: Colors.white,
                          selectedBorderColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height - 160),
            margin: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Visibility(
                visible: _saveButtonOp,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Color.fromRGBO(0, 0, 200, 0.8),
                    child: Text(
                      "Speichern",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: saveButtonPressed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
  }

  List<Widget> buildList() {
    List<Widget> list = new List();
    double sizePerDayTime = 100;
    if (_morning.length != 0) {
      list.add(getHeadline("Morgens"));
      list.add(getDivider());
      for (int i = 0; i < _morning.length; i++) {
        list.add(_buildInhalationListItems(i, _morning, 0));
      }
    }
    if (_noon.length != 0) {
      list.add(getHeadline("Mittags"));
      list.add(getDivider());
      for (int i = 0; i < _noon.length; i++) {
        list.add(_buildInhalationListItems(i, _noon, _morning.length));
      }
    }
    if (_evening.length != 0) {
      list.add(getHeadline("Abends"));
      list.add(getDivider());
      for (int i = 0; i < _evening.length; i++) {
        list.add(_buildInhalationListItems(
            i, _evening, _morning.length + _noon.length));
      }
    }
    if (_night.length != 0) {
      list.add(getHeadline("Nachts"));
      list.add(getDivider());
      for (int i = 0; i < _night.length; i++) {
        list.add(_buildInhalationListItems(
            i, _night, _morning.length + _noon.length + _evening.length));
      }
    }
    return list;
  }

  Widget getHeadline(String t) {
    return new Container(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Text(
        t,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget getDivider() {
    return new Divider(
      color: Colors.black54,
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildInhalationListItems(int index, List<Inhalation> list, int len) {
    return ListTile(
      leading: Checkbox(
        value: _inhalationDone[len + index],
        onChanged:  (bool value) {
          changedEntry(value, len+index, _inhalationDone);
        },
      ),
      title: Text(
          list[index].getAmount().toString() + "x " + list[index].getSpray()),
      subtitle: Text(list[index].getDose().toString() + " ug"),
    );
  }

  Widget _buildSymptomsAndSurroundingsListItems(int index, List<String> l) {
    return ListTile(
      leading: Checkbox(
        value: false,
        onChanged: (bool value) {
          //TODO
          changedEntry(value, index, null);
        },
      ),
      title: Text(l[index]),
    );
  }

  List<Widget> buildSymptomsAndSurroundingsList(String s, List<String> l) {
    List<Widget> list = new List();
    list.add(getHeadline(s));
    list.add(getDivider());
    for (int i = 0; i < l.length; i++) {
      list.add(_buildSymptomsAndSurroundingsListItems(i, l));
    }
    return list;
  }

  ratingButtonPressed(int index) {
    setState(() {
      for (int i = 0; i < ratingButtons.length; i++) {
        if (i == index) {
          ratingButtons[i] = true;
        } else {
          ratingButtons[i] = false;
        }
      }
      showSaveButton();
    });
  }

  ///gets all workouts gtom the database and saves them in a list
  void createDayList() async {
    List l;
    print("Create Inhalation List");
    String day = _visibleDay.day.toString() +
        _visibleDay.month.toString() +
        _visibleDay.year.toString();

    try {
      final row = await dbHelper.getList(int.parse(day));
      print("current day: " + row.toString());
      l = row.toList();
      setState(() {
        _d = new Diary.fromJson(l[0]);
        _morning = _d.getSpraysList(0);
        _noon = _d.getSpraysList(1);
        _evening = _d.getSpraysList(2);
        _night = _d.getSpraysList(3);
        for (int i = 0; i < _morning.length; i++) {
          _inhalationDone.add(_morning[i].getDone());
        }
        ;
        for (int i = 0; i < _noon.length; i++) {
          _inhalationDone.add(_noon[i].getDone());
        }
        ;
        for (int i = 0; i < _evening.length; i++) {
          _inhalationDone.add(_evening[i].getDone());
        }
        ;
        for (int i = 0; i < _night.length; i++) {
          _inhalationDone.add(_night[i].getDone());
        }
        ;
      });
    } catch (e) {
      print("Datenbank-Fehler: " + e.toString());
      //TODO: fuege neuen hinzu
    }
  }

  void previousDay() {
    int d = _visibleDay.day;
    int m = _visibleDay.month;
    int y = _visibleDay.year;
    setState(() {
      _visibleDay = new DateTime(y, m, d - 1);
      print("day: " + _visibleDay.day.toString());
      createDayList();
    });
  }

  void nextDay() {
    int d = _visibleDay.day;
    int m = _visibleDay.month;
    int y = _visibleDay.year;
    setState(() {
      _visibleDay = new DateTime(y, m, d + 1);
      print("day: " + _visibleDay.day.toString());
      createDayList();
    });
  }

  changedEntry(bool value, int index, List<bool> list) {
    setState(() {
      showSaveButton();
      list[index] = value;
    });
  }

  void showSaveButton(){
    if (!_saveButtonOp){
      _saveButtonOp = true;
    }
  }

  void saveButtonPressed() {
    //TODO Daten speichern
    setState(() {
      _saveButtonOp = false;
      //Notes, Symptoms, Others, Rating,
      //_spraysMorning, etc. muessen erst ALLE aktualisiert werden (bool-Wert)
    });
  }
}
