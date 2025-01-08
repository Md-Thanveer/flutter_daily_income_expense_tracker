import 'package:flutter/material.dart';
import 'package:flutter_daily_income_expense_tracker/screens/ExpenseTransactionScreen.dart';
import 'package:flutter_daily_income_expense_tracker/screens/IncomeTrasactionScreen.dart';

import 'AllTransactionScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<Widget> screenList = [
    const AllTransactionScreen(title: 'All',),
    const IncomeTransactionScreen(title: 'Income'),
    const ExpenseTransactionScreen(title: 'Expense'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: screenList.length, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Income Expense Manager'),
        bottom: TabBar(
          controller: _tabController, // Assign TabController
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Assign TabController
        children: screenList, // Use screenList here
      ),
    );
  }
}