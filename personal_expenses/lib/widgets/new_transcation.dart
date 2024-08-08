//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function txHandler;

  NewTransaction(this.txHandler);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amtController = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmt = double.parse(amtController.text);

    if (enteredTitle.isEmpty || enteredAmt <= 0 || _selectedDate==null) {
      return;
    }
    widget.txHandler(
      enteredTitle,
      enteredAmt,
      _selectedDate,
    );

    Navigator.of(context as BuildContext).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context as BuildContext,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((pickedDate) => {
          if (pickedDate != null) {
            setState((){
              _selectedDate = pickedDate;
            })
          }else{}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
            // onChanged: (val){
            //   titleInput=val;
            // },
            controller: titleController,
            onSubmitted: (_) => submitData(),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
            // onChanged: (val){
            //   amtInput=val;
            // },
            controller: amtController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => submitData(),
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No date chosen'
                      : DateFormat.yMd().format(_selectedDate!)),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    "Choose Date",
                    style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand'),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: submitData,
            child: Text(
              'Add Transaction',
              style: TextStyle(fontFamily: 'Quicksand'),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
