import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/model/no_ads_purchase.dart';
import 'package:money_management_app/view/ads_delete_dialog.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../extension/ios_widget_manager.dart';

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
      await compareDate();
      await _databaseController.initDb();
      // iosウィジェットを初期化
      await IosWidgetManager().invokeWidget(context, ref);
    });
  }

  Future<void> compareDate() async {
    _viewModel.setLeftDays(_leftDays);
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
                const Padding(
                  padding: EdgeInsets.all(0),
                ),
                Text(
                  L10n.of(context)!.priceAndLeftDays(_viewModel.availableMoney,_leftDays.toString()),
                  style: const TextStyle(fontSize: 30),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: L10n.of(context)!.usedMoney,
                      suffix: Text(L10n.of(context)!.currency),
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
                    decoration: InputDecoration(labelText: L10n.of(context)!.content),
                    controller: _contentController,
                  ),
                ),
                OutlinedButton(
                  onPressed: buttonTapped,
                  child: Text(L10n.of(context)!.save,
                      style: const TextStyle(
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
                                return const AdsDeleteDialog();
                              });
                        },
                        child: Text(L10n.of(context)!.deleteTheAds, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                      width: 150,
                      height: 50,
                    )),
                padding: const EdgeInsets.all(20),
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
      await _viewModel.addItem(expenseItem);
      final int saveCount = await MySharedPreferences().getSaveCountPref();

      if (saveCount % 5 == 4) {
        await AppReview.requestReview;
      }
      await IosWidgetManager().invokeWidget(context, ref);
    } else {
      // none
    }
  }
}
