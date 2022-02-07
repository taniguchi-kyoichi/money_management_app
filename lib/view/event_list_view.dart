import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/database.dart';
import 'package:money_management_app/model/db_data.dart';
import 'package:money_management_app/view/edit_view.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:sqflite/sqflite.dart';

class EventListApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const EventListApp(
    this.viewModel, {
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
  late Database _db;
  List<TodoItem> _todoList = [];

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
          body: Consumer(
            builder: (context, ref, child) => ListView(
              children: _todoList
                  .map((TodoItem todo) => _itemToListTile(todo))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateUI() async {
    await _databaseController.getTodoItems();
    setState(() {
      _todoList = _databaseController.todos;
      _db = _databaseController.db;
    });
  }

  ListTile _itemToListTile(TodoItem todoItem) {
    return ListTile(
        title: Text(
          '${todoItem.price}円',
        ),
        subtitle: Text(todoItem.content),
        isThreeLine: true,
        leading: Text('${todoItem.createdAt.month}月${todoItem.createdAt.day}日'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await _databaseController.deleteTodoItem(todoItem);
            _updateUI();
            _viewModel.deleteItem(todoItem);
          },
        ),
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditView(ViewModel(), todoItem),
              ),
            ).then((value) {
              setState(() {
                _updateUI();
              });
            }));
  }

  Future<bool> _initUI() async {
    await _databaseController.asyncInit();
    _db = _databaseController.db;
    _todoList = _databaseController.todos;

    return true;
  }
}
