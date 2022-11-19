import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function handler;
  AdaptiveButton(this.text, this.handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: () {
              handler();
            },
            child: Text(
              "Choose Date!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : TextButton(
            onPressed: () {
              handler();
            },
            child: Text(
              "Choose Date!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
          );
  }
}
