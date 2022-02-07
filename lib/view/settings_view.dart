import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);

    Future(() async {
      await _databaseController.initDb();
    });
  }

  final DatabaseController _databaseController = DatabaseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextButton(
            onPressed: () async {
              var result = await showDialog<int>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('確認'),
                    content: const Text('本当にリセットしますか？'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(0),
                        child: const Text('リセットする'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(1),
                        child: const Text('キャンセル'),
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
            child: const Text('リセット'),
          )
        ],
      ),
    );
  }
}
