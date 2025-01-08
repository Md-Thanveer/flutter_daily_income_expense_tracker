import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Transaction.dart';
import '../utils/Constants.dart';

class IncomeTransactionScreen extends StatefulWidget {
  final String title;

  const IncomeTransactionScreen({super.key, required this.title});

  @override
  State<IncomeTransactionScreen> createState() =>
      _IncomeTransactionScreenState();
}

class _IncomeTransactionScreenState extends State<IncomeTransactionScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(
          Uri.parse(Constants.BASE_URL + Constants.INCOME_TRANSACTION_ROUTE));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          transactions = data.map((row) => Transaction.fromJson(row)).toList();
          isLoading = false;
        });
      } else {
        showError('Failed to load transactions.');
        throw Exception('Failed to load transactions. ' +
            Constants.BASE_URL +
            Constants.INCOME_TRANSACTION_ROUTE);
      }
    } catch (e) {
      showError('An error occurred while fetching transactions: $e');
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   elevation: 2,
      //   backgroundColor: Colors.green.shade700,
      // ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : transactions.isEmpty
          ? const Center(
        child: Text(
          'No income transactions found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final row = transactions[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.2),
                radius: 25,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.green.shade700,
                  size: 30,
                ),
              ),
              title: Text(
                '\u20B9${row.amount}', // Indian Rupee Symbol
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    row.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    row.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.monetization_on,
                color: Colors.green.shade700,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}
