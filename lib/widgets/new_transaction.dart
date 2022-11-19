// import 'dart:html';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/widgets/adaptive_button.dart';

class newTransaction extends StatefulWidget {
  final Function addTx;

  newTransaction(this.addTx);

  @override
  State<newTransaction> createState() => _newTransactionState();
}

class _newTransactionState extends State<newTransaction> {
  final _titlecontroller = TextEditingController();

  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredtitle = _titlecontroller.text;
    final enteredamount = double.parse(_amountcontroller.text);
    if (enteredtitle.isEmpty || enteredamount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredtitle, enteredamount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentdatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                controller: _titlecontroller,
                onSubmitted: (_) => _submitData(),
                // onChanged: () {
                //   // titleinput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'amount',
                ),
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: () {},
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen!"
                          : 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}'),
                    ),
                    AdaptiveButton('Choose Date!', _presentdatepicker),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                child: Text("Add transaction!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
