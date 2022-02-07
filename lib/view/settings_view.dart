import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/view_model.dart';

class SettingsApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const SettingsApp(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends ConsumerState<SettingsApp> {
  late ViewModel _viewModel;
  final DatabaseController _databaseController = DatabaseController();
  late TextEditingController _aimMoneyController;
  final MySharedPreferences _preferences = MySharedPreferences();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);

    Future(() async {
      await _databaseController.initDb();
      int aimMoney =
          await _preferences.getAimMoneyPref() ?? Constants.initAimMoney;
      _aimMoneyController = TextEditingController(text: aimMoney.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          setInitialStateButton(),
          const Divider(
            thickness: 3,
            height: 50,
            indent: 30,
            endIndent: 30,
          ),
          resetButton(),
        ],
      ),
    );
  }

  Widget setInitialStateButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
      child: TextButton(
        child: const Text('目標金額を設定'),
        onPressed: setInitialStateDialogWidget,
      ),
    );
  }

  Future<Widget?> setInitialStateDialogWidget() async {
    var result = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('目標金額'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _aimMoneyController,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(0),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(1),
                child: const Text('OK'),
              ),
            ],
          );
        });
    if (result == 1) {
      int newData = int.parse(_aimMoneyController.text);
      _viewModel.updateAvailableMoneyProvider(newData, _viewModel.aimMoney);
      _viewModel.setAimMoney(newData);
      _preferences.setAimMoneyPref(newData);
    } else {
      // none
    }
  }

  Widget resetButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () async {
          var result = await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('確認'),
                content: const Text('本当に削除しますか？'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(1),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(0),
                    child: const Text('削除する'),
                  ),
                ],
              );
            },
          );
          if (result == 0) {
            _viewModel.resetRef();
            _databaseController.deleteAll();
          } else {
            // none
          }
        },
        child: const Text('記録を削除'),
      ),
    );
  }
}
