import 'package:flutter/material.dart';

class IncomeTrasactionScreen extends StatefulWidget {

  final String title;

  const IncomeTrasactionScreen({super.key, required this.title});

  @override
  State<IncomeTrasactionScreen> createState() => _IncomeTrasactionScreenState();
}

class _IncomeTrasactionScreenState extends State<IncomeTrasactionScreen> {
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