import 'package:flutter_todolist/model/lists/list.dart';

extension Extensions on TodoList {
  Future<int> count() async {
    final list = await items();
    return list.length;
  }
}
