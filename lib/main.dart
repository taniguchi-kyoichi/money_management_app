import 'package:flutter/material.dart';
import 'package:money_management_app/database.dart';
import 'package:money_management_app/sqlite_example.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SqliteExample()
    );
  }
}

