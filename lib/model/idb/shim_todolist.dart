import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class ShimTodoList implements TodoList {
  static const String _dbName = "todolist.db";
  static const String _storageName = "items";
  late Future<Database> _database;

  ShimTodoList() {
    IdbFactory? idbFactory = getIdbFactory("todolist");
    if (idbFactory == null) {
      throw Error();
    }
    _database = idbFactory.open(_dbName, version: 0);
  }

  @override
  Future<int> add(String title) async {
    // final db = await _database;
    // final txn = db.transaction(_storageName, "readwrite");
    // final store = txn.objectStore(_storageName);
    // final key = await store.put({"some": "data"});
    // store.
    // await txn.completed;
    throw UnimplementedError();
  }

  @override
  Future<List<Item>> items() {
    // TODO: implement items
    throw UnimplementedError();
  }

  @override
  Future<void> remove(int id) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}
