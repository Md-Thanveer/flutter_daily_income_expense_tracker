import 'package:flutter/material.dart';
import 'package:flutter_daily_income_expense_tracker/models/Transaction.dart';
import 'package:intl/intl.dart';
import '../services/TransactionService.dart';

class TransactionFormScreen extends StatefulWidget {
  final String title;
  final String? transactionId; // Nullable to support both create and update
  final Transaction? transactionData;

  const TransactionFormScreen({
    super.key,
    required this.title,
    this.transactionId,
    this.transactionData,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _transactionType;
  late String _description;
  late String? _amount;
  late DateTime _selectedDate;
  late TextEditingController _dateController;

  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();

    if (widget.transactionData != null) {
      // Prepopulate with existing data
      _transactionType = widget.transactionData!.type ?? 'INCOME';
      _description = widget.transactionData!.description ?? '';
      _amount = widget.transactionData!.amount;
      _selectedDate = DateTime.tryParse(widget.transactionData!.date) ?? DateTime.now();
    } else {
      // Default values for new transactions
      _transactionType = 'INCOME';
      _description = '';
      _amount = null;
      _selectedDate = DateTime.now();
    }

    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formattedDate = _selectedDate.toIso8601String().split('T').first;

      try {
        if (widget.transactionId != null) {
          // Update existing transaction
          await _transactionService.updateTransaction(
            id: widget.transactionId!,
            type: _transactionType,
            amount: _amount!,
            description: _description,
            date: formattedDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transaction updated successfully!')),
          );
        } else {
          // Create new transaction
          await _transactionService.createTransaction(
            type: _transactionType,
            amount: _amount,
            description: _description,
            date: formattedDate,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transaction created successfully!')),
          );
        }

        Navigator.pop(context); // Navigate back after submission
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit transaction: $error')),
        );
      }
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
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                initialValue: _amount,
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
                  _amount = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
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
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: _dateController,
                onTap: _pickDate,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.transactionId != null ? 'Update' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}