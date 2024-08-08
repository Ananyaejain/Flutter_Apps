import 'package:flutter/material.dart';
import './widgets/new_transcation.dart';
import './models/transaction.dart';
import './widgets/transactionCard.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        buttonTheme: ButtonThemeData(buttonColor: Colors.white),
        fontFamily: 'Quicksand',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'Monitor',
    //   amt: 8000,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Shoes',
    //   amt: 5000,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: 'Clothes',
    //   amt: 7000,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmt, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amt: txAmt,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id==id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Personal Expenses',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () => _startAddNewTransaction(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Chart(_recentTransactions),
              TransactionList(_userTransactions,_deleteTransaction),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          onPressed: () => _startAddNewTransaction(context),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
