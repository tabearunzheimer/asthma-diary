import 'package:flutter/material.dart';

class Inhalation {
  String _spray;
  int _dose;
  int _amount;
  bool _done;

  Inhalation(String spray, int amount) {
    _spray = spray;
    _dose = 0;
    _amount = amount;
  }

  setSpray(String spray) {
    _spray = spray;
  }

  getSpray() {
    return _spray;
  }

  setDose(int dose) {
    _dose = dose;
  }

  getDose() {
    return _dose;
  }

  setAmount(int amount) {
    _amount = amount;
  }

  getAmount() {
    return _amount;
  }

  setDone(bool b){
    _done = b;
  }

  getDone(){
    return _done;
  }

  int getDoneAsNumber(){
    if (_done){
      return 1;
    } else {
      return 0;
    }
  }

  //Aufbau: Amount1,Sprayname1,0,false;Amount2,Sprayname2,dose1,1;
  //0  =false, 1 = true
  String getFormattedAsString(){
    return _amount.toString() + "," + _spray + "," + _dose.toString() + "," + getDoneAsNumber().toString();
  }
}
