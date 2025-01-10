import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_daily_income_expense_tracker/models/Transaction.dart';
import 'package:flutter_daily_income_expense_tracker/utils/Constants.dart';

import 'package:http/http.dart' as http;

import 'TransactionFormScreen.dart';

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
      // ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : transactions.isEmpty
          ? Center(child: Text('No transactions found.'))
          : ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final row = transactions[index];
            // print(row);

            return Card(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(
                    row.type == 'INCOME'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: row.type == 'INCOME'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    '${row.type}: \$${row.amount}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(row.description),
                  trailing: Text(row.date),
                  onTap: () async {
                    // print(row.toJson());

                    // Navigator.pop(context);

                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransactionFormScreen(
                          title: 'Update Transaction',
                          transactionId: row.id.toString(),
                          transactionData: row,
                        ),
                      ),
                    );
                    // Refresh the transactions list when the user returns
                    fetchTransactions();

                  },
                ));
          }),
    );
  }
}