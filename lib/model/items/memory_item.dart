import 'package:flutter_todolist/model/items/item.dart';

class MemoryItem implements Item {
  final String _title;
  bool _done;

  MemoryItem(this._title, this._done) {}

  @override
  Future<bool> done() async {
    return _done;
  }

  @override
  Future<void> finish() async {
    _done = true;
  }

  @override
  Future<String> title() async {
    return _title;
  }
}
