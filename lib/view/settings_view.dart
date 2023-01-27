import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/my_shared_preferences.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../extension/ios_widget_manager.dart';

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
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        child: Text(L10n.of(context)!.settingAimMoney),
        onPressed: setInitialStateDialogWidget,
      ),
    );
  }

  Future<void> setInitialStateDialogWidget() async {
    var result = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(L10n.of(context)!.aimMoney),
            content: TextField(
              decoration: InputDecoration(
                suffix: Text(L10n.of(context)!.currency),
              ),
              keyboardType: TextInputType.number,
              controller: _aimMoneyController,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(0),
                child: Text(L10n.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(1),
                child: Text(L10n.of(context)!.oK),
              ),
            ],
          );
        });
    if (result == 1) {
      int newData = int.parse(_aimMoneyController.text);
      await _viewModel.updateAvailableMoneyProvider(newData, _viewModel.aimMoney);
      _viewModel.setAimMoney(newData);
      await _preferences.setAimMoneyPref(newData);
      await IosWidgetManager().invokeWidget(context, ref);
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
                title: Text(L10n.of(context)!.confirmation),
                content: Text(L10n.of(context)!.confirmAllDelete),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(1),
                    child: Text(L10n.of(context)!.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(0),
                    child: Text(L10n.of(context)!.delete),
                  ),
                ],
              );
            },
          );
          if (result == 0) {
            await _viewModel.resetRef();
            await _databaseController.deleteAll();
            await IosWidgetManager().invokeWidget(context, ref);
          } else {
            // none
          }
        },
        child: Text(L10n.of(context)!.deleteAllRecords),
      ),
    );
  }
}
