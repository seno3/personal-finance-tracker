String convertDateTimetoString(DateTime dateTime) {
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  if (day.length == 1){
    day  = '0' + day;
  }

  String yyyymmdd = year + month + day;

  return yyyymmdd;
}