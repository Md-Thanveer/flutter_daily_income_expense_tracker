import 'dart:convert';
import 'package:flutter_daily_income_expense_tracker/utils/Constants.dart';
import 'package:http/http.dart' as http;

class TransactionService {


  Future<void> createTransaction({
    required String type,
    required String? amount,
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

  // Fetch a single transaction by ID
  Future<Map<String, dynamic>?> getTransaction(String transactionId) async {
    final url = Uri.parse(
        Constants.BASE_URL + Constants.SINGLE_TRANSACTION_ROUTE.replaceFirst('{id}', transactionId));
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Success
        final data = jsonDecode(response.body);
        print("Transaction fetched successfully: $data");
        return data['data']; // Assuming the response has a 'data' key
      } else {
        // Error handling
        print("Failed to fetch transaction: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error occurred: $error");
      return null;
    }
  }

  Future<void> updateTransaction({
    required String id,
    required String type,
    required String amount,
    required String description,
    required String date,
  }) async {
    final url = Uri.parse(
      Constants.BASE_URL + Constants.UPDATE_TRANSACTION_ROUTE.replaceFirst("{id}", id),
    );
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Transaction updated successfully");
      } else {
        print("Failed to update transaction: ${response.body}");
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }
}