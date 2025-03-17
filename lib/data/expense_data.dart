import 'package:finance_tracker/data/hive_database.dart';
import 'package:finance_tracker/datetime/date_time_helper.dart';
import 'package:finance_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier{
  //list of expenses

  List<ExpenseItem> overallExpenseList = [];


  //get expense list

  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepare data

  final db = HiveDataBase();

  void prepareData(){

    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
    
  }

  // add new expense

  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense

 void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }


  //get weekday from datetime object
  
  String getDayName(DateTime dateTime){
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
        
    }
  }

  // get the date for the start of the week (monday)

  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++){
      if (getDayName(today.subtract(Duration(days: i))) == 'Mon'){
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }



  // convert overall list of expenses into daily summary

  /*

  [
  [food, 2023/01/30, $ 10],
  [chocolate, 2025/03/16, $ &],
  ]

  ->

  [2023/01/30: $ 25]
  */

  Map<String,double> calculateDailyExpenseSummary () {

    Map<String, double> dailyExpenseSummary = {
      //date (yyyy,mm,dd)


    };

    for (var expense in overallExpenseList){
      String date = convertDateTimetoString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;

        currentAmount += amount;

        dailyExpenseSummary[date] = currentAmount;
      }
      else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}