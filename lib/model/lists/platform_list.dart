import 'package:flutter/foundation.dart';
import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';

class PlatformTodoList implements TodoList {
  final Lazy<TodoList> webTodoList;
  final Lazy<TodoList> defaultTodoList;

  PlatformTodoList({required this.webTodoList, required this.defaultTodoList});

  @override
  Future<List<Item>> items() async {
    return (await _todoList()).items();
  }

  @override
  Future<int> add(String title) async {
    return (await _todoList()).add(title);
  }

  @override
  Future<void> remove(int id) async {
    return (await _todoList()).remove(id);
  }

  Future<TodoList> _todoList() {
    if (kIsWeb) return webTodoList.instance();
    return defaultTodoList.instance();
  }
}

class Lazy<T> {
  final Future<T> Function() _newInstance;
  T? cached;

  Lazy(this._newInstance);

  Future<T> instance() async {
    cached ??= await _newInstance();
    return cached!;
  }
}
