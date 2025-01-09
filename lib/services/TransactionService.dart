import 'dart:convert';
import 'package:flutter_daily_income_expense_tracker/utils/Constants.dart';
import 'package:http/http.dart' as http;
class TransactionService {
  Future<void> createTransaction({
    required String type,
    required double amount,
    required String description,
    required String date,
  }) async {
    final url = Uri.parse(Constants.BASE_URL + Constants.ADD_TRANSACTION);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // Success
        print("Transaction created successfully");
      } else {
        // Error handling
        print("Failed to create transaction: ${response.body}");
        print(Constants.BASE_URL + Constants.ADD_TRANSACTION);
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }
}