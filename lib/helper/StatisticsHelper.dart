import 'package:asthma_tagebuch/helper/Inhalation.dart';
import 'package:asthma_tagebuch/helper/date_helper.dart';
import 'package:asthma_tagebuch/helper/diary_database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Diary.dart';

class StatisticsHelper {
  final _dbHelper = DiaryDatabaseHelper.instance;
  List<Diary> _allEntries;

  StatisticsHelper() {
    _allEntries = new List();
  }

  List<int> getAmountOfSymptomsForAMonth(int month) {
    List<int> erg = new List();
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<String> l =
            _allEntries[i].separateStringByComma(_allEntries[i].getSymptoms());
        erg.add(l.length);
      }
    }
    return erg;
  }

  List<String> getDaysForAMonth(int month) {
    List<String> erg = new List();
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        erg.add(_allEntries[i].getDay().toString() +
            ". " +
            new DateHelper().getMonthName(_allEntries[i].getMonth()) +
            " " +
            _allEntries[i].getYear().toString());
      }
    }
    return erg;
  }

  List<bool> getTakenSprayForAMonth(String spray, int month) {
    List<bool> erg = new List();
    List<String> l = spray.split(' ');
    int dt = getDayTime(spray);

    int amount = 0;
    String s = l[2];
    int dose = 0;

    String h = "";
    for (int j = 0; j < l[1].length; j++) {
      if (l[1][j] != 'x') {
        h += l[1][j];
      }
    }
    amount = int.parse(h);

    h = "";
    int kp;
    if (l[3].contains("(")){
      kp = 3;
    } else {
      kp = 4;
    }

    for (int j = 0; j < l[kp].length; j++) {
      if (l[kp][j] != '(' && l[kp][j] != ')') {
        h += l[kp][j];
      }
    }
    dose = int.parse(h);

    String key = amount.toString() + "," + s + "," + dose.toString();
    //print(key);
    for (int i = 0; i < _allEntries.length; i++) {
      erg.add(_allEntries[i].searchListAndGetDone(key, dt));
      //print(erg[i]);
    }

    int amountTrue = 0;
    for (int i = 0; i < erg.length; i++) {
      if (erg[i]) {
        amountTrue++;
      }
    }
    //print("amount: $amountTrue");
    if (amountTrue < 2) {
      return new List();
    }
    return erg;
  }

  int getDayTime(String spray) {
    String r = spray[0] + spray[1] + spray[2];
    switch (r) {
      case "Mor":
        return 0;
        break;
      case "Mit":
        return 1;
        break;
      case "Abe":
        return 2;
        break;
      case "Nac":
        return 3;
        break;
    }
  }

  List<bool> getSurroundingsTakenForAMonth(int month, String surrounding) {
    List<bool> erg = new List();
    bool atLeastOneTrue = false;
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<String> l = _allEntries[i]
            .separateStringByComma(_allEntries[i].getSurroundings());

        erg.add(false);
        for (int j = 0; j < l.length; j++) {
          //print("l: " + l[i] + " l[j]: " + l[j] + " sur: " + surrounding);
          if (l[j] == surrounding) {
            erg[i] = true;
            atLeastOneTrue = true;
          }
        }
      }
    }
    for (int i = 0; i < erg.length; i++) {
      //print("list: " + erg[i].toString());
    }
    if (!atLeastOneTrue) {
      return new List();
    }
    return erg;
  }

  Future<List<String>> getAllUsedSpraysWithDayTimeByMonth(int month) async {
    List<String> erg = new List();

    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<Inhalation> l = _allEntries[i].getSpraysList(0); //morgens
        for (int j = 0; j < l.length; j++) {
          String s = "";
          if (j == 0) {
            s = ("Morgens: " + l[j].getAmount().toString() + "x " + l[j].getSpray() + " (" + l[j].getDose().toString() + ")");
          } else {
            for (int k = 0; k < erg.length; k++) {
              if (("Morgens: " +
                      l[j].getAmount().toString() +
                      "x " +
                      l[j].getSpray() +
                      " (" +
                      l[j].getDose().toString() +
                      ")") !=
                  erg[k]) {
                s = ("Morgens: " +
                    l[j].getAmount().toString() +
                    "x " +
                    l[j].getSpray() +
                    " (" +
                    l[j].getDose().toString() +
                    ")");
              }
            }
          }
          if (s != "") {
            erg.add(s);
          }
        }
      }
    }
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<Inhalation> l = _allEntries[i].getSpraysList(1); //Mittags
        for (int j = 0; j < l.length; j++) {
          String s = "";
          if (j == 0) {
            s = ("Mittags: " +
                l[j].getAmount().toString() +
                "x " +
                l[j].getSpray() +
                " (" +
                l[j].getDose().toString() +
                ")");
          } else {
            for (int k = 0; k < erg.length; k++) {
              if (("Mittags: " +
                      l[j].getAmount().toString() +
                      "x " +
                      l[j].getSpray() +
                      " (" +
                      l[j].getDose().toString() +
                      ")") !=
                  erg[k]) {
                s = ("Mittags: " +
                    l[j].getAmount().toString() +
                    "x " +
                    l[j].getSpray() +
                    " (" +
                    l[j].getDose().toString() +
                    ")");
              }
            }
          }
          if (s != "") {
            erg.add(s);
          }
        }
      }
    }
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<Inhalation> l = _allEntries[i].getSpraysList(2); //Abends
        for (int j = 0; j < l.length; j++) {
          String s = "";
          if (j == 0) {
            s = ("Abends: " +
                l[j].getAmount().toString() +
                "x " +
                l[j].getSpray() +
                " (" +
                l[j].getDose().toString() +
                ")");
          } else {
            for (int k = 0; k < erg.length; k++) {
              if (("Abends: " +
                      l[j].getAmount().toString() +
                      "x " +
                      l[j].getSpray() +
                      " (" +
                      l[j].getDose().toString() +
                      ")") !=
                  erg[k]) {
                s = ("Abends: " +
                    l[j].getAmount().toString() +
                    "x " +
                    l[j].getSpray() +
                    " (" +
                    l[j].getDose().toString() +
                    ")");
              }
            }
          }
          if (s != "") {
            erg.add(s);
          }
        }
      }
    }
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<Inhalation> l = _allEntries[i].getSpraysList(3); //nachts
        for (int j = 0; j < l.length; j++) {
          String s = "";
          if (j == 0) {
            s = ("Nachts: " +
                l[j].getAmount().toString() +
                "x " +
                l[j].getSpray() +
                " (" +
                l[j].getDose().toString() +
                ")");
          } else {
            for (int k = 0; k < erg.length; k++) {
              if (("Nachts: " +
                      l[j].getAmount().toString() +
                      "x " +
                      l[j].getSpray() +
                      " (" +
                      l[j].getDose().toString() +
                      ")") !=
                  erg[k]) {
                s = ("Nachts: " +
                    l[j].getAmount().toString() +
                    "x " +
                    l[j].getSpray() +
                    " (" +
                    l[j].getDose().toString() +
                    ")");
              }
            }
          }
          if (s != "") {
            erg.add(s);
          }
        }
      }
    }
    for (int i = 0; i < _allEntries.length; i++) {
      if (_allEntries[i].getMonth() == month) {
        List<Inhalation> l = _allEntries[i].getSpraysList(4); //morgens
        for (int j = 0; j < l.length; j++) {
          String s = "";
          if (j == 0) {
            s = ("Bedarf: " + l[j].getAmount().toString() + "x " + l[j].getSpray() + " (" + l[j].getDose().toString() + ")");
          } else {
            for (int k = 0; k < erg.length; k++) {
              if (("Bedarf: " +
                  l[j].getAmount().toString() +
                  "x " +
                  l[j].getSpray() +
                  " (" +
                  l[j].getDose().toString() +
                  ")") !=
                  erg[k]) {
                s = ("Bedarf: " +
                    l[j].getAmount().toString() +
                    "x " +
                    l[j].getSpray() +
                    " (" +
                    l[j].getDose().toString() +
                    ")");
              }
            }
          }
          if (s != "") {
            erg.add(s);
          }
        }
      }
    }

    for(int i = 0; i < erg.length; i++){
      for (int j = 0; j < erg.length; j++){
        if (erg[i] == erg[j] && i != j){
          erg.removeAt(j);
        }
      }
    }

    //print("erg: " + erg.length.toString());
    return erg;
  }

  Future getDatabaseEntries() async {
    List l;
    List<Diary> entries = new List();
    try {
      final allRows = await _dbHelper.queryAllRows();
      final listLength = await _dbHelper.queryRowCount();

      l = allRows.toList();
      for (int i = 0; i < listLength; i++) {
        entries.add(new Diary.fromJson(l[i]));
      }
      _allEntries = entries;
    } catch (ex) {
      print("Datenbank-Fehler: " + ex.toString());
    }
  }
}
