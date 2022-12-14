import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_data.dart';

class DatabaseController {
  static const kDbFileName = 'sqflite_ex.db';
  static const kDbTableName = 'example_tbl';
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  late Database db;
  List<ExpenseItem> expenseItemList = [];

  // Opens a db local file. Creates the db table if it's not yet created.
  Future<void> initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY, 
          price INTEGER,
          content TEXT,
          createdAt INT)
        ''',
        );
      },
    );
  }

  // Retrieves rows from the db table.
  Future<void> getExpenseItems() async {
    final List<Map<String, dynamic>> jsons =
        await db.rawQuery('SELECT * FROM $kDbTableName');
    expenseItemList = jsons.map((json) => ExpenseItem.fromJsonMap(json)).toList();
  }

  // Inserts records to the db table.
  // Note we don't need to explicitly set the primary key (id), it'll auto
  // increment.
  Future<void> addExpenseItem(ExpenseItem expenseItem) async {
    await db.transaction(
      (Transaction txn) async {
        await txn.rawInsert(
          '''
          INSERT INTO $kDbTableName
            (price, content, createdAt)
          VALUES
            (
              "${expenseItem.price}",
              "${expenseItem.content}",
              ${expenseItem.createdAt.millisecondsSinceEpoch}
            )''',
        );
      },
    );
  }

  Future<void> changePrice(ExpenseItem oldItem, int price) async {
    ExpenseItem newExpense = ExpenseItem(
        id: oldItem.id,
        price: price,
        content: oldItem.content,
        createdAt: oldItem.createdAt);
    await db.update(kDbTableName, newExpense.toJsonMap(),
        where: 'id = ?', whereArgs: [oldItem.id]);
  }

  // Deletes records in the db table.
  Future<void> deleteExpenseItem(ExpenseItem expense) async {
    await db.rawDelete(
      '''
        DELETE FROM $kDbTableName
        WHERE id = ${expense.id}
      ''',
    );
  }

  asyncInit() async {
    // Avoid this function to be called multiple times,
    // cf. https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
    await _memoizer.runOnce(() async {
      await initDb();
      await getExpenseItems();
    });
  }

  Future<void> deleteAll() async {
    await db.rawDelete(
      '''
        DELETE FROM $kDbTableName
      ''',
    );
  }
}
