import '../items/item.dart';

abstract class TodoList {
  Future<List<Item>> items();

  Future<int> add(String title);

  Future<void> remove(int id);
}
