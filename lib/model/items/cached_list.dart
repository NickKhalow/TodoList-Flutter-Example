import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';

class CachedTodoList implements TodoList {
  final TodoList _origin;
  Future<List<Item>>? _cached;

  CachedTodoList(this._origin);

  @override
  Future<int> add(String title) {
    _cached = null;
    return _origin.add(title);
  }

  @override
  Future<List<Item>> items() {
    _cached ??= _origin.items();
    return _cached!;
  }

  @override
  Future<void> remove(int id) async {
    _origin.remove(id);
  }
}
