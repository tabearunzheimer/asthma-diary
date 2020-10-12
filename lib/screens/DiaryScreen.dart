import 'package:asthma_tagebuch/helper/Diary.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:asthma_tagebuch/helper/date_helper.dart';
import 'package:asthma_tagebuch/helper/diary_database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  int _selectedIndex = 1;
  ReusableWidgets _reusableWidgets;

  final dbHelper = DiaryDatabaseHelper.instance;
  List<Diary> _diaryList;

  @override
  void initState() {
    super.initState();
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);

    _diaryList = new List();
    getDatabaseEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _reusableWidgets.getNormalAppBar(),
      body: ListView.builder(
        itemCount: _diaryList.length,
        itemBuilder: buildListViewItems,
      ),
      bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
  }

  Widget buildListViewItems(BuildContext context, int index) {
    List<Widget> l = new List();
    if (_diaryList[index].getSpraysList(0).length +
            _diaryList[index].getSpraysList(1).length +
            _diaryList[index].getSpraysList(2).length +
            _diaryList[index].getSpraysList(3).length !=
        0) {
      l.add(
        getHeadline(_diaryList[index].getDay().toString() +
            ". " +
            new DateHelper().getMonthName(_diaryList[index].getMonth()) +
            " " +
            _diaryList[index].getYear().toString() + " - Bewertung: " + _diaryList[index].getRatingAsString()),
      );
      l.add(getDivider());
    }
    List<Widget> zw = new List();
    if (_diaryList[index].getSpraysList(0).length != 0) {
      zw.add(getDayTimeEntries("Morgens", 0, _diaryList[index]));
    }
    if (_diaryList[index].getSpraysList(1).length != 0) {
      zw.add(getDayTimeEntries("Mittags", 1, _diaryList[index]));
    }
    if (_diaryList[index].getSpraysList(2).length != 0) {
      zw.add(getDayTimeEntries("Abends", 2, _diaryList[index]));
    }
    if (_diaryList[index].getSpraysList(3).length != 0) {
      zw.add(getDayTimeEntries("Nachts", 3, _diaryList[index]));
    }
    l.add(
      new Card(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: new BorderSide(
            color: Color.fromRGBO(0, 0, 200, 1),
          ),
        ),
        child: Column(
          children: zw,
        ),
      ),
    );

    if (_diaryList[index].getSymptoms().length != 0) {
      l.add(
        Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: new BorderSide(
              color: Color.fromRGBO(0, 0, 200, 1),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aufgetretene Symptome",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(
                  color: Colors.black54,
                ),
                Text(_diaryList[index].getSymptoms()),
              ],
            ),
          ),
        ),
      );
    }

    if (_diaryList[index].getSurroundings().length != 0) {
      l.add(
        new Card(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: new BorderSide(
              color: Color.fromRGBO(0, 0, 200, 1),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Umstände des Tages",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(
                  color: Colors.black54,
                ),
                Text(_diaryList[index].getSurroundings()),
              ],
            ),
          ),
        ),
      );
    }

    return new Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: l,
      ),
    );
  }

  Widget getDayTimeEntries(String headline, int element, Diary d) {
    List<Widget> zw = new List();
    zw.add(Text(
      headline,
      style: TextStyle(fontSize: 16),
    ));
    zw.add(Divider(
      color: Colors.black54,
    ));
    for (int i = 0; i < d.getSpraysList(element).length; i++) {
      String taken = d.getSpraysList(element)[i].getDone() ? "Ja" : "Nein";
      zw.add(Text(d.getSpraysList(element)[i].getAmount().toString() +
          "x " +
          d.getSpraysList(element)[i].getSpray() +
          " (" +
          d.getSpraysList(element)[i].getDose().toString() +
          "ug) genommen: " +
          taken));
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: zw,
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

  void getDatabaseEntries() async {
    List l;
    List<Diary> entries = new List();
    print("Create Diary List");

    try {
      final allRows = await dbHelper.queryAllRows();
      final listLength = await dbHelper.queryRowCount();

      print("List-Length: " + listLength.toString());
      l = allRows.toList();
      for (int i = 0; i < listLength; i++) {
        entries.add(new Diary.fromJson(l[i]));
      }
      setState(() {
        _diaryList = entries;
      });
    } catch (ex) {
      print("Datenbank-Fehler: " + ex.toString());
    }
  }
}
