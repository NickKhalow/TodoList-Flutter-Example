import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/items/memory_item.dart';
import 'package:flutter_todolist/model/lists/list.dart';

class MemoryTodoList implements TodoList {
  final Map<int, Item> _items;

  MemoryTodoList(this._items);

  @override
  Future<List<Item>> items() async {
    return List<Item>.unmodifiable(_items.values);
  }

  @override
  Future<int> add(String title) async {
    var item = MemoryItem(title, false);
    _items[item.hashCode] = item;
    return item.hashCode;
  }

  @override
  Future<void> remove(int id) async {
    _items.remove(id);
  }
}
