import 'package:flutter/material.dart';

class SplitTest extends StatelessWidget {
  String test = "Hi My ";

  @override
  Widget build(BuildContext context) {
    List<String> list = test.split(RegExp(r" *"));
    for (int i = 0; i < list.length; i++) {
      print(list[i]);
    }
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
