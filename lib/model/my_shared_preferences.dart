import 'package:money_management_app/configs/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{

  Future<int?> getAvailableMoneyPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.availableMoneyPref);
  }

  Future<int?> getAimMoneyPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.aimMoneyPref);
  }

  Future<int?> getCurrentTimePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.currentTimePref);
  }

  setAvailableMoneyPref(int newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.availableMoneyPref, newData);
  }


  setAimMoneyPref(int newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.aimMoneyPref, newData);
  }

  setCurrentTimePref(int newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.currentTimePref, newData);
  }

  Future<bool> getIsNoAdsPurchasePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? res = prefs.getBool(Constants.isNoAdsPurchasePref);
    if (res != null) {
      return res;
    } else {
      await setIsNoAdsPurchasePref(false);
      return false;
    }

  }

  setIsNoAdsPurchasePref(bool newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.isNoAdsPurchasePref, newData);
  }

  Future<String> getWidgetTitlePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? res = prefs.getString(Constants.widgetTitlePref);
    if (res != null) {
      return res;
    } else {
      await setWidgetTitlePref("");
      return "";
    }

  }

  setWidgetTitlePref(String newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.widgetTitlePref, newData);
  }

  Future<int> getSaveCountPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? res = prefs.getInt("saveCount");
    if (res != null) {
      return res;
    } else {
      await setSaveCountPref(0);
      return 0;
    }

  }

  setSaveCountPref(int newData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("saveCount", newData);
  }
}