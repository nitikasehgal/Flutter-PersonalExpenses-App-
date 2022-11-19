import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:personal_expense/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenttransactions;
  Chart(this.recenttransactions);
  List<Map<String, Object>> get groupedtransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalsum = 0.0;
      for (var i = 0; i < recenttransactions.length; i++) {
        if (recenttransactions[i].date.day == weekday.day &&
            recenttransactions[i].date.month == weekday.month &&
            recenttransactions[i].date.year == weekday.year) {
          totalsum += recenttransactions[i].amount;
        }
        ;
      }
      print(DateFormat.E().format(weekday));
      print(totalsum);
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedtransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedtransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedtransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: chartBar(
                    data['day'].toString(),
                    data['amount'] as double,
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalSpending),
              );
            }).toList(),
          ),
        ));
  }
}
