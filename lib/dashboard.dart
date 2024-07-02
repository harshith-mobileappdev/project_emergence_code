import 'package:flutter/material.dart';
import 'expense_tracker.dart';
import 'investment_tracker.dart';
import 'income.dart';
import 'saving_goal.dart';
import 'helpers/database_helper.dart';
import 'Reports.dart';


class Dashboard extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadGoal();
    _loadIncome();
    _loadExpenses();
    // Initialize with a default goal value (e.g., 0.0)
  }
  double currentGoal=0.0;
  double currentIncome=0.0;
  double totalExpense=0.0;
  double totalInvestment=0.0;

  Future<void> _loadGoal() async {
    try {
      double goal = await DatabaseHelper.instance.getGoal() as double;
      setState(() {
        currentGoal = goal;
      });
    } catch (error) {
      print('Error loading goal: $error');
      // Handle error, e.g., show an error message
    }
  }

  Future<void> _loadIncome() async {
    try {
      double income = await DatabaseHelper.instance.getIncome() as double;
      setState(() {
        currentIncome = income;
      });
    } catch (error) {
      print('Error loading income: $error');
      // Handle error, e.g., show an error message
    }
  }

  Future<void> _loadExpenses() async {
    try {
      double expenseAmount = await DatabaseHelper.instance.calculateTotalExpenseAmount() as double;
      setState(() {
        totalExpense = expenseAmount;
      });
    } catch (error) {
      print('Error loading total expenses: $error');
      // Handle error, e.g., show an error message
    }
  }

  Future<void> _loadInvestments() async {
    try {
      double investmentAmount = await DatabaseHelper.instance.calculateTotalInvestmentAmount() as double;
      setState(() {
        totalInvestment = investmentAmount;
      });
    } catch (error) {
      print('Error loading total expenses: $error');
      // Handle error, e.g., show an error message
    }
  }

  void _navigateToExpenseTracker(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseTracker()),
    );
    await _loadExpenses();
    print('Total expenses are $totalExpense');
  }

  void _navigateToInvestmentTracker(BuildContext context) async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvestmentTracker()),
    );
    await _loadInvestments();
    print('Total investments are $totalInvestment');
  }

  void _navigateToIncomeTracker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Income()),
    );
    await _loadIncome();
    print('Current income is $currentIncome');
  }

  void _navigateToSavingGoal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavingGoal()),
    );
    await _loadGoal();
    print('Current goal is $currentGoal');
  }

  void _getReport() async{
    await _loadGoal();
    await _loadIncome();
    await _loadInvestments();
    await _loadExpenses();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Reports(currentIncome,totalExpense,totalInvestment,currentGoal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Finance Manager'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToExpenseTracker(context),
              child: Text('Expense Tracker'),
            ),
            SizedBox(height: 20.0), // Add some space between the buttons
            ElevatedButton(
              onPressed:()=> _navigateToInvestmentTracker(context),
              child: Text('Investment Tracker'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: ()=>_navigateToIncomeTracker(context),
              child: Text('Income Entry'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: ()=>_navigateToSavingGoal(context),
              child: Text('Budget Goal Setting'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: ()=> _getReport(),
              child: Text('Reports'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
