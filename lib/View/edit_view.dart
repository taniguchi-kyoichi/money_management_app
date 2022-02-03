import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/Model/db_data.dart';
import 'package:money_management_app/view_model/view_model.dart';

class EditView extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  final TodoItem todoItem;

  const EditView(
    this.viewModel, this.todoItem, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditView> createState() => _EditViewState();
}

class _EditViewState extends ConsumerState<EditView> {
  late ViewModel _viewModel;
  late TodoItem _todoItem;
  late TextEditingController _cashController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _todoItem = widget.todoItem;
    _cashController = TextEditingController(text: _todoItem.price.toString());
    _contentController = TextEditingController(text: _todoItem.content);

    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('編集画面'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${_todoItem.createdAt}'),
            TextField(
              keyboardType: TextInputType.number,
              controller: _cashController,
            ),
            TextField(
              controller: _contentController,
            ),

          ],
        ),
      ),
    );
  }
}
