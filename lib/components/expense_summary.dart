import 'package:finance_tracker/bargraph/bar_graph.dart';
import 'package:finance_tracker/data/expense_data.dart';
import 'package:finance_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  //calculate max

  double calculateMax(ExpenseData value, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday, String sunday)
  {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,

    ];
    values.sort();

    max = values.last * 1.1;

    return max == 0 ? 100: max;
  }
  //week total

  String calculateWeekTotal(ExpenseData value, String monday, String tuesday, String wednesday, String thursday, String friday, String saturday, String sunday) {
    double weekTotal = 0;
    List<double> values = [
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
      value.calculateDailyExpenseSummary()[sunday] ?? 0,

    ];
    for (int i = 0; i< values.length; i++){
      weekTotal += values[i];
    }

    return weekTotal.toStringAsFixed(2);

  }
  @override
  Widget build(BuildContext context) {
    String monday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 0)));
    String tuesday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 1)));
    String wednesday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 2)));
    String thursday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 3)));
    String friday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 4)));
    String saturday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 5)));
    String sunday =
        convertDateTimetoString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
        builder: (context, value, child) => Column(
          children: [
            //week total

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text('Week Total:'),
                  Text(calculateWeekTotal(value, monday, tuesday, wednesday, thursday, friday, saturday, sunday))
                ],
              ),
            ),
            SizedBox(
                height: 200,
                child: BarGraph(
                    maxY: calculateMax(value, monday, tuesday, wednesday, thursday, friday, saturday, sunday),
                    monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
                    tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                    wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                    thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
                    friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
                    satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
                    sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,)),
          ],
        ));
  }
}
