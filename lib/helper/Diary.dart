/*
  static final columnId = '_id';
  static final columnSpraysMorning = 'spraysMorning';
  static final columnSpraysNoon = 'spraysNoon';
  static final columnSpraysEvening = 'spraysEvening';
  static final columnSpraysNight = 'spraysNight';
  static final columnRating = 'rating';
  static final columnOthers = 'others';
  static final columnSymptoms = 'symptoms';
  static final columnDay = 'day';
  static final columnMonth = 'month';
  static final columnYear = 'year';
 */

import 'package:asthma_tagebuch/helper/Inhalation.dart';

class Diary{

  int _id;
  List <Inhalation> _spraysMorning;
  List <Inhalation> _spraysNoon;
  List <Inhalation> _spraysEvening;
  List <Inhalation> _spraysNight;
  int _rating;
  String _others;
  String _symptoms;
  DateTime _date;
  String _notes;

  Diary(int id, String spraysMorning, String spraysNoon, String spraysEvening, String spraysNight, int rating, String others, String symptoms, int day, int month, int year, String notes){
    _id = id;
    _spraysMorning = separateSpraysString(spraysMorning);
    _spraysNoon = separateSpraysString(spraysNoon);
    _spraysEvening = separateSpraysString(spraysEvening);
    _spraysNight = separateSpraysString(spraysNight);
    _rating = rating;
    _others = others;
    _symptoms = symptoms;
    _date = DateTime(year, month, day);
    _notes = notes;
    //print("init");
  }

  List <Inhalation> getSpraysList (int index){
    switch(index){
      case 0: return _spraysMorning;
      break;
      case 1: return _spraysNoon;
      break;
      case 2: return _spraysEvening;
      break;
      case 3: return _spraysNight;
      break;
      default: return null;
    }
  }

  //Aufbau: Amount1,Sprayname1,0,false;Amount2,Sprayname2,dose1,1;
  //0  =false, 1 = true
  List <Inhalation> separateSpraysString(String spraysString){
    List <Inhalation> erg = new List<Inhalation>();
    if (spraysString != null){
      List <String> split = spraysString.split(";");
      for (int k = 0; k < split.length; k++){
        String number = "";
        String spray = "";
        String dose = "";
        String done = "";
        bool numberFound = false;
        bool nameFound = false;
        bool doseFound = false;
        for (int j = 0; j < split[k].length; j++){
          if (!numberFound && split[k][j] != ','){
            number += split[k][j];
          } else if (split[k][j] == ',' && !numberFound){
            numberFound = true;
          } else if (!nameFound && split[k][j] != ',' ){
            spray += split[k][j];
          } else if (split[k][j] == ',' && !nameFound) {
            nameFound = true;
          } else if (!doseFound && split[k][j] != ','){
            dose += split[k][j];
          } else if (!doseFound && split[k][j] == ','){
            doseFound = true;
          } else {
            done += split[k][j];
          }
        }
        if (number != "" && spray != "" && dose != "" && done != "") {
          //print("number: " + number + " spray: " + spray + " dosis: " + dose + " done: " + done);
          Inhalation i = new Inhalation(spray, int.parse(number));
          i.setDose(int.parse(dose));
          bool d = int.parse(done) == 0 ? false : true;
          i.setDone(d);
          erg.add(i);
        }
    }
    }
    return erg;
  }

  String getSymptoms(){
    return _symptoms;
  }

  String getSurroundings(){
    return _others;
  }

  String getNotes(){
    return _notes;
  }

  String createSpraysString(List<Inhalation> list){
    String erg = "";
    for (int i = 0; i < list.length; i++){
      erg += "${list[i].getAmount()},${list[i].getSpray()},${list[i].getDose()},${list[i].getDoneAsNumber()};";
    }
    return erg;
  }

  List <String> separateStringByComma(String s){
    List <String> split = s.split(",");
    return split;
  }

  factory Diary.fromJson(Map<String, dynamic> parsedJson) {
    Diary d = new Diary(
      parsedJson['_id'],
      parsedJson['spraysMorning'],
      parsedJson['spraysNoon'],
      parsedJson['spraysEvening'],
      parsedJson['spraysNight'],
      parsedJson['rating'],
      parsedJson['others'],
      parsedJson['symptoms'],
      parsedJson['day'],
      parsedJson['month'],
      parsedJson['year'],
      parsedJson['notes'],
    );
    return d;
  }

  void _setId(){
    _id = int.parse(_date.day.toString() + _date.month.toString() + _date.year.toString());
  }

  void setRating(int r){
    _rating = r;
  }

  void setOthers(String others){
    _others = others;
  }

  void setSymptoms(String s){
    _symptoms = s;
  }

  void setNotes(String s){
    _notes = s;
  }


}