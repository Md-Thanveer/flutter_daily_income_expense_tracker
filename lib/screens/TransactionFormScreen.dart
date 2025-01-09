import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/TransactionService.dart';

class TransactionFormScreen extends StatefulWidget {

  final String title;

  const TransactionFormScreen({super.key, required this.title});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {

  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'INCOME';
  String _description = '';
  double? _amount;
  DateTime _selectedDate = DateTime.now();

  final TransactionService _transactionService = TransactionService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle submission logic here
      print('Transaction Type: $_transactionType');
      print('Amount: $_amount');
      print('Description: $_description');
      print('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');

      final formattedDate = _selectedDate.toIso8601String().split('T').first;

      try {
        await _transactionService.createTransaction(
          type: _transactionType,
          amount: _amount!,
          description: _description,
          date: formattedDate,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction created successfully!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _transactionType = 'income';
          _selectedDate = DateTime.now();
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create transaction: $error')),
        );
      }

      // Reset form or navigate
      setState(() {
        _transactionType = 'INCOME';
      });

    }
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Transaction Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text('INCOME'),
                      value: 'INCOME',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text('EXPENSE'),
                      value: 'EXPENSE',
                      groupValue: _transactionType,
                      onChanged: (value) {
                        setState(() {
                          _transactionType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                      ),
                      onTap: _pickDate,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}