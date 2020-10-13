import 'package:asthma_tagebuch/helper/Diary.dart';
import 'package:asthma_tagebuch/helper/Inhalation.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;
  ReusableWidgets _reusableWidgets;

  static const String userMorningSprays = 'userMorningSprays';
  static const String userNoonSprays = 'userNoonSprays';
  static const String userEveningSprays = 'userEveningSprays';
  static const String userNightSprays = 'userNightSprays';
  static const String userDemandSprays = 'userDemandSprays';
  SharedPreferences prefs;

  Diary _d = new Diary(0, "", "", "", "", 0, "", "", 0, 0, 0, "", "");
  List<Inhalation> _morning;
  List<Inhalation> _noon;
  List<Inhalation> _evening;
  List<Inhalation> _night;
  List<Inhalation> _demand;

  TextEditingController _sprayName = new TextEditingController();
  TextEditingController _sprayAmount = new TextEditingController();
  TextEditingController _sprayDose = new TextEditingController();

  List<bool> _memories;
  List<String> _allergies = ["Birkenpollen", "Buchenpollen", "Eschenpollen"];
  List<String> _others = ["Bettwäsche waschen", "Staub wischen"];

  @override
  void initState() {
    super.initState();
    _morning = new List();
    _noon = new List();
    _evening = new List();
    _night = new List();
    _demand = new List();

    _memories = new List();

    for (int i = 0; i < _allergies.length + _others.length; i++) {
      _memories.add(false);
    }

    SharedPreferences.getInstance().then((sp) {
      this.prefs = sp;
      loadString(userMorningSprays);
      loadString(userNoonSprays);
      loadString(userEveningSprays);
      loadString(userNightSprays);
      loadString(userDemandSprays);
      for (int i  = 0; i < _allergies.length; i++){
        loadBool(_allergies[i], i);
      }
      for (int i  = 0; i < _others.length; i++){
        loadBool(_others[i], _allergies.length+i);
      }
    });
  }

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
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: new BorderSide(
                                  color: Color.fromRGBO(0, 0, 200, 1),
                                ),
                              ),
                              child:
                                  createInhalationList("Morgens", _morning, 0),
                            ),
                            Card(
                              //color: Colors.green,
                              margin: EdgeInsets.all(5),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: new BorderSide(
                                  color: Color.fromRGBO(0, 0, 200, 1),
                                ),
                              ),
                              child: createInhalationList("Mittags", _noon, 1),
                            ),
                            Card(
                              //color: Colors.blue,
                              margin: EdgeInsets.all(5),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: new BorderSide(
                                  color: Color.fromRGBO(0, 0, 200, 1),
                                ),
                              ),
                              child:
                                  createInhalationList("Abends", _evening, 2),
                            ),
                            Card(
                              //color: Colors.green,
                              margin: EdgeInsets.all(5),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: new BorderSide(
                                  color: Color.fromRGBO(0, 0, 200, 1),
                                ),
                              ),
                              child: createInhalationList("Nachts", _night, 3),
                            ),
                            Card(
                              //color: Colors.green,
                              margin: EdgeInsets.all(5),
                              shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: new BorderSide(
                                  color: Color.fromRGBO(0, 0, 200, 1),
                                ),
                              ),
                              child: createInhalationList(
                                  "Sport und Notfall", _demand, 4),
                            ),
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
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: new BorderSide(
                                    color: Color.fromRGBO(0, 0, 200, 1),
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: createMemoryEntries(
                                        _allergies, 0, "Allergien"),
                                  ),
                                )),
                            Card(
                                //color: Colors.green,
                                margin: EdgeInsets.all(5),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: new BorderSide(
                                    color: Color.fromRGBO(0, 0, 200, 1),
                                  ),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: createMemoryEntries(
                                        _others, _allergies.length, "Sonstige"),
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

  List<Widget> createMemoryEntries(
      List<String> list, int index, String headline) {
    List<Widget> l = new List();
    l.add(
      Text(
        headline,
        style: TextStyle(fontSize: 18),
      ),
    );
    l.add(
      Divider(
        color: Colors.black54,
        thickness: 0.5,
      ),
    );
    for (int i = 0; i < list.length; i++) {
      l.add(createSwitchEntry(list[i], i + index));
    }
    return l;
  }

  Widget createSwitchEntry(String s, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(s),
        Switch(
          value: _memories[index],
          onChanged: (bool value) {
            setState(() {
              _memories[index] = value;
              setBool(s, value);
            });
          },
        ),
      ],
    );
  }

  Widget createInhalationList(
      String headline, List<Inhalation> list, int element) {
    List<Widget> l = new List();
    l.add(
      new Text(
        headline,
        style: TextStyle(fontSize: 18),
      ),
    );
    l.add(
      Divider(
        color: Colors.black54,
        thickness: 0.5,
      ),
    );
    if (list.length == 0) {
      l.add(addEntryButton(list, 0, element));
    } else {
      for (int i = 0; i < list.length; i++) {
        l.add(createInhalationListItems(i, list, element));
      }
      l.add(addEntryButton(list, l.length, element));
    }

    Container c = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: l,
      ),
    );
    return c;
  }

  Widget addEntryButton(List<Inhalation> list, int index, int element) {
    return FlatButton(
      onPressed: () {
        //print("change entry");
        changeEntryDialog(list, index, element);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Füge einen Eintrag hinzu"),
          Icon(
            (Icons.add),
          ),
        ],
      ),
    );
  }

  Widget createInhalationListItems(
      int index, List<Inhalation> list, int element) {
    return ListTile(
      title: Text(
          list[index].getAmount().toString() + "x " + list[index].getSpray()),
      subtitle: Text(list[index].getDose().toString() + "ug"),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          changeEntryDialog(list, index, element);
        },
      ),
    );
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

  void loadString(String key) async {
    setState(() {
      //("Get data");
      switch (key) {
        case 'userMorningSprays':
          String s = prefs.get(key) ?? "No Data";
          //print("s: " + s);
          _morning = _d.separateSpraysString(s);
          //print("Morning: " + _morning.length.toString());
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
        case 'userDemandSprays':
          String s = prefs.get(key) ?? "No Data";
          _demand = _d.separateSpraysString(s);
          break;
      }
    });
  }

  Future<Null> setString(String key, String g) async {
    await this.prefs.setString(key, g);
    //print("String saved");
  }

  void loadBool(String key, int index) async {
    setState(() {
      //print("Get data");
      bool b = prefs.get(key) ?? false;
      //print("bool: " + b.toString());
      _memories[index] = b;
    });
  }

  Future<Null> setBool(String key, bool b) async {
    await this.prefs.setBool(key, b);
    //print("Bool saved");
  }

  void changeEntryDialog(List<Inhalation> list, int index, int element) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text("Bitte gib dein Medikament ein."),
        elevation: 1,
        contentPadding: EdgeInsets.all(10),
        children: <Widget>[
          TextField(
            controller: _sprayAmount,
            decoration: InputDecoration(
              filled: true,
              labelText: "Anzahl der Hübe/ Tabletten",
            ),
          ),
          Container(
            height: 20,
          ),
          TextField(
            controller: _sprayName,
            decoration: InputDecoration(
              filled: true,
              labelText: "Name des Medikaments",
            ),
          ),
          Container(
            height: 20,
          ),
          TextField(
            controller: _sprayDose,
            decoration: InputDecoration(
              filled: true,
              labelText: "Dosierung des Medikaments in ug",
            ),
          ),
          Row(
            children: [
              FlatButton(
                child: Text("Löschen"),
                onPressed: () {
                  setState(() {
                    list.removeAt(index);
                    String s = _d.createSpraysStringWithoutDone(list);
                    setString(getKeyByElement(element), s);
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Abbrechen"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Speichern"),
                onPressed: () {
                  //setString(userNameKey, _nametext.text);
                  setState(() {
                    Inhalation i = new Inhalation(
                        _sprayName.text, int.parse(_sprayAmount.text));
                    i.setDose(int.parse(_sprayDose.text));
                    list.add(i);
                    String s = _d.createSpraysStringWithoutDone(list);
                    setString(getKeyByElement(element), s);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String getKeyByElement(int element) {
    switch (element) {
      case 0:
        return userMorningSprays;
        break;
      case 1:
        return userNoonSprays;
        break;
      case 2:
        return userEveningSprays;
        break;
      case 3:
        return userNightSprays;
        break;
      case 4:
        return userDemandSprays;
        break;
    }
    return "";
  }
}
