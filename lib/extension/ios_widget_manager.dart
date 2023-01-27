import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/provider.dart';

class IosWidgetManager {
  Future<void> invokeWidget(BuildContext context, WidgetRef ref) async {
    await MySharedPreferences().setWidgetTitlePref(L10n.of(context)!
        .priceAndLeftDays(
           ref.watch(availableMoneyProvider),
            ref.watch(leftDaysProvider).toString()));

    const methodChannel =
        MethodChannel('com.kyoichi.moneyManagementApp/widget');
    try {
      final bool result =
          await methodChannel.invokeMethod('setDataForWidgetKit');
      // ignore: avoid_print
      print('SET setUserDefaultsForAppGroup: $result');
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('ERROR setUserDefaultsData: ${e.message}');
    }
  }
}
