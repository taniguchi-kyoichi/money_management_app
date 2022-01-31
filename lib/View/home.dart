import 'package:flutter/material.dart';
import 'package:money_management_app/Model/database.dart';
import 'package:money_management_app/Model/db_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.sum})
      : super(key: key);

  final int sum;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sum = 30000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('残り${sum}円'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '使った金額'),
            )
          ],
        ),
      ),
    );
  }
}
