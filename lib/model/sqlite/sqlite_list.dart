import 'package:flutter/widgets.dart';
import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';
import 'package:flutter_todolist/model/sqlite/sqlite_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteTodoList implements TodoList {
  final Future<Database> _database;
  static const String _tableName = "todolist";

  SqliteTodoList(this._database);

  static Future<SqliteTodoList> newInstance(
      {String databaseName = "todolist.db"}) async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title TEXT, done INTEGER)',
        );
      },
      version: 1,
    );

    return SqliteTodoList(database);
  }

  @override
  Future<List<Item>> items() async {
    final db = await _database;
    final maps = await db.query(_tableName);

    List<Item> items = [];
    items.length = maps.length;

    for (var pairs in maps) {
      items.add(SqliteItem(pairs['id'] as int, _tableName, _database));
    }

    return items;
  }

  @override
  Future<int> add(String title) async {
    final db = await _database;
    return db.insert(
        _tableName, _Model(id: 0, title: title, done: false).toMap());
  }

  @override
  Future<void> remove(int id) async {
    final db = await _database;
    db.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}

class _Model {
  final int id;
  final String title;
  final bool done;

  const _Model({required this.id, required this.title, required this.done});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
    };
  }
}
