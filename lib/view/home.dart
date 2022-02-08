import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HomeApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const HomeApp(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends ConsumerState<HomeApp> {
  late ViewModel _viewModel;
  final MySharedPreferences _preferences = MySharedPreferences();
  final DateTime _currentTime = DateTime.now();
  int _leftDays = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);
    _leftDays = DateTime(_currentTime.year, _currentTime.month + 1, 0).day - _currentTime.day + 1;

    Future(() async {
      await _databaseController.initDb();
      await compareDate();

    });
  }

  Future<void> compareDate() async {
    DateTime previousTime;
    try{
      previousTime = DateTime.parse(_preferences.getCurrentTimePref().toString());
    } catch(_) {
      previousTime = DateTime.now();
    }


    if (previousTime.month != _currentTime.month) {
      _viewModel.setInit(_viewModel.aimMoney);
    } else {
      // none
    }

  }

  final DatabaseController _databaseController = DatabaseController();
  late Database _db;

  int _cash = 0;
  String _content = '';
  final _cashController = TextEditingController();
  final _contentController = TextEditingController();

  final numberFormatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            Text(
              '残り$_leftDays日で${numberFormatter.format(_viewModel.availableMoney)}円',
              style: const TextStyle(fontSize: 30),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '使った金額',
                  suffix: Text('円'),
                ),
                controller: _cashController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: TextField(
                decoration: const InputDecoration(labelText: '内容'),
                controller: _contentController,
              ),
            ),
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ),
            OutlinedButton(

              onPressed: buttonTapped,
              child: const Text('保存',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(260, 60),
                primary: Colors.blue,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
            ),
          ],
        ),
      ),
    );
  }

  buttonTapped() async {
    if (_contentController.text != '' && _cashController.text != '') {
      _cash = int.parse(_cashController.text);
      _content = _contentController.text;
      _cashController.text = '';
      _contentController.text = '';

      TodoItem todoItem = TodoItem(
        price: _cash,
        content: _content,
        createdAt: DateTime.now(),
      );
      await _databaseController.addTodoItem(todoItem);
      _viewModel.addItem(todoItem);
    } else {
      // none
    }
  }
}
