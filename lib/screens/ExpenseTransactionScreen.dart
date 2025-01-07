import 'package:flutter/material.dart';

class ExpenseTransactionScreen extends StatefulWidget {

  final String title;

  const ExpenseTransactionScreen({super.key, required this.title});

  @override
  State<ExpenseTransactionScreen> createState() => _ExpenseTransactionScreenState();
}

class _ExpenseTransactionScreenState extends State<ExpenseTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}