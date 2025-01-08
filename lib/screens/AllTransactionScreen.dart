import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_daily_income_expense_tracker/models/Transaction.dart';
import 'package:flutter_daily_income_expense_tracker/utils/Constants.dart';
import 'package:http/http.dart' as http;

class AllTransactionScreen extends StatefulWidget {
  final String title;

  const AllTransactionScreen({super.key, required this.title});

  @override
  State<AllTransactionScreen> createState() => _AllTransactionScreenState();
}

class _AllTransactionScreenState extends State<AllTransactionScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final response = await http
          .get(Uri.parse(Constants.BASE_URL + Constants.ALL_TRANSACTION_ROUTE));

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
            Constants.ALL_TRANSACTION_ROUTE);
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
      //   elevation: 0,
      //   backgroundColor: Colors.indigo,
      // ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : transactions.isEmpty
          ? const Center(
        child: Text(
          'No transactions found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
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
                backgroundColor: row.type == 'INCOME'
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                child: Icon(
                  row.type == 'INCOME'
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: row.type == 'INCOME'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              title: Text(
                '₹${row.amount}',
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
              trailing: Text(
                row.type,
                style: TextStyle(
                  fontSize: 14,
                  color: row.type == 'INCOME'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
