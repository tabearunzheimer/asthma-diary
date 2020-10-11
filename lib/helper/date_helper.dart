class DateHelper{


  ///returns the name of the month starting with 1 for Januar
  String getMonthName(int month) {
    String erg = "";
    switch (month) {
      case 1:
        erg = "Januar";
        break;
      case 2:
        erg = "Februar";
        break;
      case 3:
        erg = "März";
        break;
      case 4:
        erg = "April";
        break;
      case 5:
        erg = "Mai";
        break;
      case 6:
        erg = "Juni";
        break;
      case 7:
        erg = "Juli";
        break;
      case 8:
        erg = "August";
        break;
      case 9:
        erg = "September";
        break;
      case 10:
        erg = "Oktober";
        break;
      case 11:
        erg = "November";
        break;
      case 12:
        erg = "Dezemeber";
        break;
    }
    return erg;
  }


}