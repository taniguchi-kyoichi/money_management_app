import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/extension/ios_widget_manager.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/provider.dart';

class ViewModel {
  late WidgetRef _ref;

  final MySharedPreferences _preferences = MySharedPreferences();

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  WidgetRef getRef() {
    return _ref;
  }


  get availableMoney => _ref.watch(availableMoneyProvider).toInt();

  get aimMoney => _ref.watch(aimMoneyProvider).toInt();

  Future<void> setInit(int initMoney) async {
    _ref.watch(availableMoneyProvider.state).state = initMoney;

    await _preferences
        .setAvailableMoneyPref(initMoney);

  }
  Future<void> setLeftDays(int leftDays) async {
    _ref.watch(leftDaysProvider.notifier).state = leftDays;
  }


  void setAimMoney(int data) {
    _ref.watch(aimMoneyProvider.state).state = data;
  }

  Future<void> addItem(ExpenseItem expenseItem) async {
    _ref.watch(availableMoneyProvider.state).state =
        _ref.watch(availableMoneyProvider) - expenseItem.price;
    await _preferences
        .setAvailableMoneyPref(_ref.watch(availableMoneyProvider.state).state);
  }

  Future<void> deleteItem(ExpenseItem expenseItem) async {
    _ref.watch(availableMoneyProvider.state).state =
        _ref.watch(availableMoneyProvider) + expenseItem.price;
    await _preferences
        .setAvailableMoneyPref(_ref.watch(availableMoneyProvider.state).state);
  }

  Future<void> updateAvailableMoneyProvider(int add, int subtract) async {
    _ref.watch(availableMoneyProvider.state).state =
        _ref.watch(availableMoneyProvider) + add - subtract;
    await _preferences
        .setAvailableMoneyPref(_ref.watch(availableMoneyProvider.state).state);
  }

  Future<void> resetRef() async {
    _ref.watch(aimMoneyProvider.state).state = Constants.initAimMoney;
    _ref.watch(availableMoneyProvider.state).state = Constants.initAimMoney;
    _preferences
        .setAvailableMoneyPref(_ref.watch(availableMoneyProvider.state).state);
  }
}
