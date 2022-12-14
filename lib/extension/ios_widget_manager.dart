import 'package:flutter/services.dart';

class IosWidgetManager{
  Future<void> initMethodChannel() async {
    const methodChannel = MethodChannel('com.kyoichi.moneyManagementApp/widget');
    try {
      final bool result = await methodChannel.invokeMethod('setDataForWidgetKit');
      // ignore: avoid_print
      print('SET setUserDefaultsForAppGroup: $result');
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('ERROR setUserDefaultsData: ${e.message}');
    }

  }
}