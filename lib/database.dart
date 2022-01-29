import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_data.dart';

class DatabaseController{
  static const kDbFileName = 'sqflite_ex.db';
  static const kDbTableName = 'example_tbl';
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  late Database db;
  List<TodoItem> todos = [];


  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    this.db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY, 
          isDone BIT NOT NULL,
          content TEXT,
          createdAt INT)
        ''',
        );
      },
    );
  }

  // Retrieves rows from the db table.
  Future<void> getTodoItems() async {
    final List<Map<String, dynamic>> jsons =
    await this.db.rawQuery('SELECT * FROM $kDbTableName');
    print('${jsons.length} rows retrieved from db!');
    this.todos = jsons.map((json) => TodoItem.fromJsonMap(json)).toList();
  }

  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.
  Future<void> addTodoItem(TodoItem todo) async {
    await this.db.transaction(
          (Transaction txn) async {
        final int id = await txn.rawInsert(
          '''
          INSERT INTO $kDbTableName
            (content, isDone, createdAt)
          VALUES
            (
              "${todo.content}",
              ${todo.isDone ? 1 : 0}, 
              ${todo.createdAt.millisecondsSinceEpoch}
            )''',
        );
        print('Inserted todo item with id=$id.');
      },
    );
  }

  // Updates records in the db table.
  Future<void> toggleTodoItem(TodoItem todo) async {
    final int count = await this.db.rawUpdate(
      /*sql=*/ '''
      UPDATE $kDbTableName
      SET isDone = ?
      WHERE id = ?''',
      /*args=*/ [if (todo.isDone) 0 else 1, todo.id],
    );
    print('Updated $count records in db.');
  }

  // Deletes records in the db table.
  Future<void> deleteTodoItem(TodoItem todo) async {
    final count = await this.db.rawDelete(
      '''
        DELETE FROM $kDbTableName
        WHERE id = ${todo.id}
      ''',
    );
    print('Updated $count records in db.');
  }

    asyncInit() async {
    // Avoid this function to be called multiple times,
    // cf. https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
    await _memoizer.runOnce(() async {
      await initDb();
      await getTodoItems();
    });
  }




}
