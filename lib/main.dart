import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/widgets/chart_data.dart';
import 'package:personal_expense/widgets/new_transaction.dart';
import 'package:personal_expense/widgets/transaction_list.dart';
// import 'package:personal_expense/widgets/user_transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          // appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(titleLarge: ))
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransaction = [
    // Transaction(id: 't1', title: 'Watch', amount: 69.9, date: DateTime.now()),
    // Transaction(
    //     id: 't2', title: 'Red Tape Shoes', amount: 55.5, date: DateTime.now()),
  ];
  bool _showChart = false;

  List<Transaction> get _recenttransaction {
    return _usertransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addnewtransaction(String title, double amount, DateTime chosendate) {
    final newtx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosendate);
    setState(() {
      _usertransaction.add(newtx);
    });
  }

  void _startAddnewtransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: newTransaction(_addnewtransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deletetransactions(String id) {
    setState(() {
      _usertransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    final isPortrait = mediaquery.orientation == Orientation.portrait;
    final dynamic appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses!'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _startAddnewtransaction(context);
                  },
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses!'),
            actions: [
              IconButton(
                  onPressed: () {
                    _startAddnewtransaction(context);
                  },
                  icon: const Icon(Icons.add))
            ],
          );
    final txListWidget = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.7,
        child: transactionList(_usertransaction, _deletetransactions));

    final pagebody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Chart!"),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaquery.size.height -
                        appbar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.3,
                child: Chart(_recenttransaction),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaquery.size.height -
                              appbar.preferredSize.height -
                              mediaquery.padding.top) *
                          0.7,
                      child: Chart(_recenttransaction),
                    )
                  : txListWidget
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pagebody,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            body: pagebody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddnewtransaction(context);
                    },
                    child: Icon(Icons.add),
                  ),
          );
  }
}
