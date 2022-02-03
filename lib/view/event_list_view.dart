import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/Model/database.dart';
import 'package:money_management_app/View/edit_view.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/db_data.dart';

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
                  .map((TodoItem todo) => _itemToListTile(todo, ref))
                  .toList(),
            ),
          ),
          floatingActionButton: Consumer(
              builder: (context, ref, child) =>
                  _buildFloatingActionButton(ref)),
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

  ListTile _itemToListTile(TodoItem todo, WidgetRef ref) {
    return ListTile(
      title: Text(
        todo.content,
      ),
      subtitle: Text('id=${todo.id}\ncreated at ${todo.createdAt}'),
      isThreeLine: true,
      leading: Text('${todo.price}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await _databaseController.deleteTodoItem(todo);
          _updateUI();
          _viewModel.deleteItem(todo);
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditView(ViewModel(), todo),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        TodoItem todoItem = TodoItem(
          price: 200,
          content: english_words.generateWordPairs().first.asPascalCase,
          createdAt: DateTime.now(),
        );
        await _databaseController.addTodoItem(todoItem);
        _updateUI();
        _viewModel.addItem(todoItem);
      },
      child: const Icon(Icons.add),
    );
  }

  Future<bool> _initUI() async {
    await _databaseController.asyncInit();
    _db = _databaseController.db;
    _todoList = _databaseController.todos;

    return true;
  }
}
