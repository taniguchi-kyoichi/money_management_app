import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/view/edit_view.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../extension/ios_widget_manager.dart';

class EventListApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;


  const EventListApp(
    this.viewModel,{
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EventListApp> createState() => _EventListAppState();
}

class _EventListAppState extends ConsumerState<EventListApp> {
  late ViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);
  }

  final DatabaseController _databaseController = DatabaseController();
  List<ExpenseItem> _expenseItemList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initUI(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: ListView(
            children: _expenseItemList
                .map((ExpenseItem expense) => _itemToListTile(expense))
                .toList(),
          ),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    await _databaseController.getExpenseItems();
    setState(() {
      _expenseItemList = _databaseController.expenseItemList;
    });
  }

  ListTile _itemToListTile(ExpenseItem expenseItem) {
    return ListTile(
        title: Text(
          L10n.of(context)!.price(expenseItem.price),
        ),
        subtitle: Text(expenseItem.content),
        isThreeLine: true,
        leading: Text('${expenseItem.createdAt.month}/${expenseItem.createdAt.day}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async => deleteConfirmDialog(expenseItem),
        ),
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditView(ViewModel(), expenseItem),
              ),
            ).then((value) {
              setState(() {
                _updateUI();
              });
            }));
  }

  Future<void> deleteConfirmDialog(ExpenseItem expenseItem) async {
    var result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${expenseItem.createdAt.month}/${expenseItem.createdAt.day} ${L10n.of(context)!.price(expenseItem.price)}\n${expenseItem.content}'),
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
      await _databaseController.deleteExpenseItem(expenseItem);
      _updateUI();
      await _viewModel.deleteItem(expenseItem);
      await IosWidgetManager().invokeWidget(context, ref);
    } else {
      // none
    }
  }

  Future<bool> _initUI() async {
    await _databaseController.asyncInit();
    _expenseItemList = _databaseController.expenseItemList;

    return true;
  }
}
