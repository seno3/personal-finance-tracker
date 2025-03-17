import 'dart:ffi';

import 'package:finance_tracker/components/expense_summary.dart';
import 'package:finance_tracker/components/expense_tile.dart';
import 'package:finance_tracker/data/expense_data.dart';
import 'package:finance_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();

  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // prepare data

    Provider.of<ExpenseData> (context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: InputDecoration(
                hintText: "Name"
              ),
            ),
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Amount"
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),
          MaterialButton(onPressed: cancel, child: Text('Cancel')),
        ],
      ),
    );
  }
  //delete

  void deleteExpense(ExpenseItem expense){
    Provider.of<ExpenseData>(context,listen:false).deleteExpense(expense);

  }

  void save() {

    if (newExpenseNameController.text.isNotEmpty && newExpenseAmountController.text.isNotEmpty){
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }
    Navigator.pop(context);
  }

  void cancel() {}

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: addNewExpense, child: Icon(Icons.add, color: Colors.white,)),
        body: ListView(children: [
          
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height:50),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
                  
                  )),
                  
            
        ]),
      ),
    );
  }
}
