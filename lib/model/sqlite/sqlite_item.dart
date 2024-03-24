import 'package:sqflite/sqflite.dart';

import '../items/item.dart';

class SqliteItem implements Item {
  final int _id;
  final String _table;
  final Future<Database> _database;

  SqliteItem(this._id, this._table, this._database);

  @override
  Future<String> title() async {
    final db = await _database;
    final result = await db.query(
        _table, columns: ['title'], where: 'id = ?', whereArgs: [_id]);
    return result.first['title'] as String;
  }

  @override
  Future<bool> done() async {
    final db = await _database;
    final result = await db.query(
        _table, columns: ['done'], where: 'id = ?', whereArgs: [_id]);
    return result.first['done'] as int != 0;
  }

  @override
  Future<void> finish() async {
    final db = await _database;
    final result = await db.update(
        _table, {'done': 1}, where: 'id = ?', whereArgs: [_id]);
    if (result != 1) {
      throw Error();
    }
  }
}
