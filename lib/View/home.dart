import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  int _cash = 0;
  String _content = '';
  final _cashController = TextEditingController();
  final _contentController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer(
                builder: (context, ref, child) =>
                    Text('${ref.watch(availableMoneyProvider).toInt()}')),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '使った金額'),
              controller: _cashController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: '内容'),
              controller: _contentController,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_contentController.text != '' && _cashController.text != '') {
                    _cash = int.parse(_cashController.text);
                    _content = _contentController.text;
                    print('$_cash');
                    print(_content);
                    _cashController.text = '';
                    _contentController.text = '';
                  } else {
                    // none
                  }

                },
                child: Text('保存'))
          ],
        ),
      ),
    );
  }
}
