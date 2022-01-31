import 'package:flutter/material.dart';
import 'package:money_management_app/Model/database.dart';
import 'package:money_management_app/Model/db_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/view_model/provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title, required this.sum})
      : super(key: key);

  final int sum;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final availableMoney = ref.watch(availableMoneyProvider);
    
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('残り${availableMoney}円'),
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
