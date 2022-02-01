import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/Model/database.dart';
import 'package:money_management_app/view_model/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/db_data.dart';

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key? key, required this.sum}) : super(key: key);

  final int sum;

  @override
  _SqliteExampleState createState() => _SqliteExampleState();
}

class _SqliteExampleState extends State<SqliteExample> {
  DatabaseController _databaseController = DatabaseController();
  late Database _db;
  List<TodoItem> _todos = [];

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
              children: _todos.map((TodoItem todo) => _itemToListTile(todo, ref)).toList(),
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
      _todos = _databaseController.todos;
      _db = _databaseController.db;
    });
  }

  ListTile _itemToListTile(TodoItem todo, WidgetRef ref) => ListTile(
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
            ref.watch(availableMoneyProvider.state).state =
                ref.watch(availableMoneyProvider) + todo.price;
          },
        ),
      );

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
        ref.watch(availableMoneyProvider.state).state =
            ref.watch(availableMoneyProvider) - todoItem.price;
      },
      child: const Icon(Icons.add),
    );
  }

  Future<bool> _initUI() async {
    await _databaseController.asyncInit();
    _db = _databaseController.db;
    _todos = _databaseController.todos;

    return true;
  }
}
