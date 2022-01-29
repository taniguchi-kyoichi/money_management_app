import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:money_management_app/Model/database.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/db_data.dart';

class SqliteExample extends StatefulWidget {
  const SqliteExample({Key? key}) : super(key: key);

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
          body: ListView(
            children: this._todos.map(_itemToListTile).toList(),
          ),
          floatingActionButton: _buildFloatingActionButton(),
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

  ListTile _itemToListTile(TodoItem todo) => ListTile(
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
      },
    ),
  );

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await _databaseController.addTodoItem(
          TodoItem(
            price: 200,
            content: english_words.generateWordPairs().first.asPascalCase,
            createdAt: DateTime.now(),
          ),
        );
        _updateUI();
      },
      child: const Icon(Icons.add),
    );
  }

  Future<bool> _initUI() async{

    await _databaseController.asyncInit();
    _db = _databaseController.db;
    _todos = _databaseController.todos;

    return true;
  }

}