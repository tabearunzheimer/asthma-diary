import 'package:asthma_tagebuch/helper/Diary.dart';
import 'package:asthma_tagebuch/helper/Inhalation.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:asthma_tagebuch/helper/date_helper.dart';
import 'package:asthma_tagebuch/helper/diary_database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController _notesController = new TextEditingController();
  String _notes;
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
    "Bedarfsmedikation genommen",
    "Bettzeug waschen",
    "Krank",
    "Putzen",
    "Sport",
  ];
  DateTime _visibleDay;
  List<bool> ratingButtons = [true, false, false];
  List<bool> _symptomsAndSurroundingsChecked;

  final dbHelper = DiaryDatabaseHelper.instance;
  SharedPreferences prefs;

  static const String userMorningSprays = 'userMorningSprays';
  static const String userNoonSprays = 'userNoonSprays';
  static const String userEveningSprays = 'userEveningSprays';
  static const String userNightSprays = 'userNightSprays';

  @override
  void initState() {
    super.initState();
    _d = new Diary(0, "", "", "", "", 0, "", "", 0, 0, 0, "");
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);
    _morning = new List<Inhalation>();
    _noon = new List<Inhalation>();
    _evening = new List<Inhalation>();
    _night = new List<Inhalation>();
    _inhalationDone = new List<bool>();
    _symptomsAndSurroundingsChecked = new List<bool>();

    for (int i = 0; i < _symptoms.length + _surroundings.length; i++) {
      _symptomsAndSurroundingsChecked.add(false);
    }

    _visibleDay = new DateTime.now();
    _saveButtonOp = false;
    //dbHelper.insertList();
    SharedPreferences.getInstance().then((sp) {
      this.prefs = sp;
      loadString(userMorningSprays);
      loadString(userNoonSprays);
      loadString(userEveningSprays);
      loadString(userNightSprays);
    });
    createDayList();
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
                      children: buildInhalationList(),
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSymptomsAndSurroundingsList(
                          "Aufgetretene Symptome", _symptoms, 0),
                    ),
                  ),
                  Card(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSymptomsAndSurroundingsList(
                          "Umstände des Tages",
                          _surroundings,
                          _symptoms.length),
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
                            controller: _notesController,
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

  List<Widget> buildInhalationList() {
    List<Widget> list = new List();
    double sizePerDayTime = 100;
    if (_morning.length + _noon.length + _evening.length + _night.length == 0) {
      list.add(
        Container(
          padding: EdgeInsets.all(10),
          color: Color.fromRGBO(0, 0, 200, 1),
          child: Text(
            "Bitte füge deine Sprays unter den Einstellungen hinzu",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
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
        onChanged: (bool value) {
          changedEntry(value, len + index, _inhalationDone, list, index);
        },
      ),
      title: Text(
          list[index].getAmount().toString() + "x " + list[index].getSpray()),
      subtitle: Text(list[index].getDose().toString() + " ug"),
    );
  }

  Widget _buildSymptomsAndSurroundingsListItems(int index, List<String> l, int adding) {
    return ListTile(
      leading: Checkbox(
        value: _symptomsAndSurroundingsChecked[index + adding],
        onChanged: (bool value) {
          changedEntry(value, index + adding, _symptomsAndSurroundingsChecked, null, 0);
        },
      ),
      title: Text(l[index]),
    );
  }

  List<Widget> buildSymptomsAndSurroundingsList(
      String s, List<String> l, int index) {
    List<Widget> list = new List();
    list.add(getHeadline(s));
    list.add(getDivider());
    for (int i = 0; i < l.length; i++) {
      list.add(_buildSymptomsAndSurroundingsListItems(i, l, index));
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

        _inhalationDone = new List();
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
        List<String> symp = _d.separateStringByComma(_d.getSymptoms());
        List<String> sur = _d.separateStringByComma(_d.getSurroundings());

        _symptomsAndSurroundingsChecked = new List();
        for (int i = 0; i < _symptoms.length; i++) {
          _symptomsAndSurroundingsChecked.add(false);
          for (int j = 0; j < symp.length; j++) {
            if (symp[j] == _symptoms[i]) {
              _symptomsAndSurroundingsChecked[i] = true;
            }
          }
          //print("symptoms-i: " + i.toString() + " symp: " + symp.length.toString() + " bool: " + _symptomsAndSurroundingsChecked[i].toString());
        }

        int offset = _symptomsAndSurroundingsChecked.length == 0 ? 0 : -1;

        for (int i = 0; i < _surroundings.length; i++) {
          _symptomsAndSurroundingsChecked.add(false);
          for (int j = 0; j < sur.length; j++) {
            print("i: " + i.toString() + " j: " + j.toString() + " sur-length: " + _surroundings.length.toString());
            if (sur[j] == _surroundings[i]) {
              //print("check: " + _symptomsAndSurroundingsChecked.length.toString() + " o: " + (_symptomsAndSurroundingsChecked.length+offset).toString());
              _symptomsAndSurroundingsChecked[_symptomsAndSurroundingsChecked.length+offset] = true;
            }
          }
        }
        //print("checked: " + _symptomsAndSurroundingsChecked.length.toString() + " sym+sur: " + (_symptoms.length + _surroundings.length).toString());
        this._notesController.text = _d.getNotes();
      });
    } catch (ex) {
      print("Datenbank-Fehler: " + ex.toString());

      setState(() {
        loadString(userMorningSprays);
        loadString(userNoonSprays);
        loadString(userEveningSprays);
        loadString(userNightSprays);
        _inhalationDone = new List();
        _symptomsAndSurroundingsChecked = new List();

        for (int i = 0; i < _morning.length + _noon.length + _evening.length + _night.length; i++) {
          _inhalationDone.add(false);
        }
        for (int i = 0; i < _symptoms.length + _surroundings.length; i++){
          _symptomsAndSurroundingsChecked.add(false);
        }
      });
    }
  }

  String getSymptomsAndSurroundingsString(int index, List<String> list) {
    String erg = "";
    for (int i = 0; i < list.length; i++) {
      if (_symptomsAndSurroundingsChecked[i + index]) {
        erg += list[i] + ",";
      }
    }
    return erg;
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

  changedEntry(bool value, int index, List<bool> list, List<Inhalation> inh, int i) {
    setState(() {
      showSaveButton();
      //print("value: " + value.toString() + " index: " + index.toString() + " list: " + _symptomsAndSurroundingsChecked[index].toString());
      list[index] = value;
      if (inh != null){
        inh[i].setDone(value);
      }
    });
  }

  void showSaveButton() {
    if (!_saveButtonOp) {
      _saveButtonOp = true;
    }
  }

  void saveButtonPressed() {
    setState(() {
      _saveButtonOp = false;

      int id = int.parse(_visibleDay.day.toString() +
          _visibleDay.month.toString() +
          _visibleDay.year.toString());
      int r;
      for (int i = 0; i < ratingButtons.length; i++) {
        if (ratingButtons[i]) {
          r = i;
        }
      }
      String m = _d.createSpraysString(_morning);
      String no = _d.createSpraysString(_noon);
      String e = _d.createSpraysString(_evening);
      String ni = _d.createSpraysString(_night);
      String symp = getSymptomsAndSurroundingsString(0, _symptoms);
      String sur =
          getSymptomsAndSurroundingsString(_symptoms.length, _surroundings);
      this._notes = _notesController.text;

      _d = new Diary(id, m, no, e, ni, r, symp, sur, _visibleDay.day,
          _visibleDay.month, _visibleDay.year, _notes);

      Map<String, dynamic> map = {
        DiaryDatabaseHelper.columnId: id,
        DiaryDatabaseHelper.columnDay: _visibleDay.day,
        DiaryDatabaseHelper.columnMonth: _visibleDay.month,
        DiaryDatabaseHelper.columnYear: _visibleDay.year,
        DiaryDatabaseHelper.columnSymptoms: symp,
        DiaryDatabaseHelper.columnOthers: sur,
        DiaryDatabaseHelper.columnRating: r,
        DiaryDatabaseHelper.columnSpraysNight: ni,
        DiaryDatabaseHelper.columnSpraysMorning: m,
        DiaryDatabaseHelper.columnSpraysEvening: e,
        DiaryDatabaseHelper.columnSpraysNoon: no,
        DiaryDatabaseHelper.columnNotes: _notes
      };
      try {
        dbHelper.update(map);
      } catch (ex) {
        print("Fehler beim speichern: " + ex);
        dbHelper.insert(map);
      }
    });
  }

  void loadString(String key) async {
    setState(() {
      //print("Get data");
      switch (key) {
        case 'userMorningSprays':
          String s = prefs.get(key) ?? "No Data";
          print("Morning: " + s);
          _morning = _d.separateSpraysString(s);
          break;
        case 'userNoonSprays':
          String s = prefs.get(key) ?? "No Data";
          _noon = _d.separateSpraysString(s);
          break;
        case 'userEveningSprays':
          String s = prefs.get(key) ?? "No Data";
          _evening = _d.separateSpraysString(s);
          break;
        case 'userNightSprays':
          String s = prefs.get(key) ?? "No Data";
          _night = _d.separateSpraysString(s);
          break;
      }
    });
  }
}
