import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);

    Future(() async {
      await _databaseController.initDb();
    });
  }

  final DatabaseController _databaseController = DatabaseController();
  late Database _db;

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
            Text('残り${_viewModel.availableMoney}円'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '使った金額'),
              controller: _cashController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: '内容'),
              controller: _contentController,
            ),
            ElevatedButton(
                onPressed: () {
                  buttonTapped();
                },
                child: const Text('保存'))
          ],
        ),
      ),
    );
  }

  buttonTapped() async {
    if (_contentController.text != '' && _cashController.text != '') {
      _cash = int.parse(_cashController.text);
      _content = _contentController.text;
      print('$_cash');
      print(_content);
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
