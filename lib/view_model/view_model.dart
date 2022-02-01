import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel {
  late WidgetRef _ref;

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  get availableMoney => _ref.watch(availableMoneyProvider).toInt();

  void setInit(int initMoney) {
    _ref.watch(availableMoneyProvider.state).state = initMoney;
  }
}