abstract class Item {
  Future<String> title();

  Future<bool> done();

  Future<void> finish();
}
