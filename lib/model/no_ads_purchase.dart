import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/provider.dart';

class NoAdsPurchase {

  Future<void> purchase(WidgetRef ref) async {
    await MySharedPreferences().setIsNoAdsPurchasePref(true);
    ref.watch(isNoAdsPurchaseProvider.notifier).state = true;
  }

  Future<void> loadPurchase(WidgetRef ref) async {
    bool isPurchase = await MySharedPreferences().getIsNoAdsPurchasePref();
    ref.watch(isNoAdsPurchaseProvider.notifier).state = isPurchase;
  }

}