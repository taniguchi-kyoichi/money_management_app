import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/model/noads_purchase.dart';
import 'package:money_management_app/view/AdsDeleteDialog.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:money_management_app/view_model/view_model.dart';

class HomeApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const HomeApp({Key? key, required this.viewModel})
      : super(key: key);

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
    _leftDays = DateTime(_currentTime.year, _currentTime.month + 1, 0).day -
        _currentTime.day +
        1;

    Future(() async {
      await NoAdsPurchase().loadPurchase(_viewModel.getRef());
      await _databaseController.initDb();
      await compareDate();
    });
  }

  Future<void> compareDate() async {
    DateTime previousTime;
    try {
      previousTime =
          DateTime.parse(_preferences.getCurrentTimePref().toString());
    } catch (_) {
      previousTime = DateTime.now();
    }

    if (previousTime.month != _currentTime.month) {
      _viewModel.setInit(_viewModel.aimMoney);
    } else {
      // none
    }
  }

  final DatabaseController _databaseController = DatabaseController();

  int _cash = 0;
  String _content = '';
  final _cashController = TextEditingController();
  final _contentController = TextEditingController();

  final numberFormatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
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
          ref.watch(isNoAdsPurchaseProvider) ? const Padding(padding: EdgeInsets.zero) : Column(
            children: [
              Padding(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (_) {
                                return AdsDeleteDialog();
                              });
                        },
                        child: const Text("広告を削除", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                      width: 150,
                      height: 50,
                    )),
                padding: EdgeInsets.all(20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buttonTapped() async {
    if (_contentController.text != '' && _cashController.text != '') {
      _cash = int.parse(_cashController.text);
      _content = _contentController.text;
      _cashController.text = '';
      _contentController.text = '';

      ExpenseItem expenseItem = ExpenseItem(
        price: _cash,
        content: _content,
        createdAt: DateTime.now(),
      );
      await _databaseController.addExpenseItem(expenseItem);
      _viewModel.addItem(expenseItem);
    } else {
      // none
    }
  }
}
