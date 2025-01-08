import 'package:flutter/material.dart';
class TransactionFormScreen extends StatefulWidget {
  final String title;
  const TransactionFormScreen({super.key, required this.title});
  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}
class _TransactionFormScreenState extends State<TransactionFormScreen> {
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