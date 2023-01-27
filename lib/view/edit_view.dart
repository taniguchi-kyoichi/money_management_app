import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../extension/ios_widget_manager.dart';

class EditView extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  final ExpenseItem expenseItem;

  const EditView(
    this.viewModel,
    this.expenseItem, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditView> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  late ViewModel _viewModel;
  late ExpenseItem expenseItem;
  late TextEditingController _cashController;
  late TextEditingController _contentController;
  final DatabaseController _databaseController = DatabaseController();

  @override
  void initState() {
    super.initState();
    expenseItem = widget.expenseItem;
    _cashController = TextEditingController(text: expenseItem.price.toString());
    _contentController = TextEditingController(text: expenseItem.content);
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);

    Future(() async {
      await _databaseController.initDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          await _viewModel.updateAvailableMoneyProvider(
              expenseItem.price, int.parse(_cashController.text));
          await IosWidgetManager().invokeWidget(context, ref);
          Navigator.of(context).pop();
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(L10n.of(context)!.editing),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${expenseItem.createdAt.month}/${expenseItem.createdAt.day}',
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                    suffix: Text(L10n.of(context)!.currency),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _cashController,
                  onChanged: (_) async {
                    _databaseController.changePrice(
                        expenseItem, int.parse(_cashController.text));
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: _contentController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
