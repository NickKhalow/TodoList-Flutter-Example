import 'package:flutter/material.dart';
import 'package:flutter_todolist/async/extensions_async.dart';
import 'package:flutter_todolist/model/items/cached_list.dart';
import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';
import 'package:flutter_todolist/model/lists/memory_list.dart';
import 'package:flutter_todolist/model/lists/platform_list.dart';
import 'package:flutter_todolist/model/sqlite/sqlite_list.dart';

void main() async {
  final TodoList todoList = CachedTodoList(PlatformTodoList(
      webTodoList: Lazy<TodoList>(() => Future(() => MemoryTodoList({}))),
      defaultTodoList: Lazy<TodoList>(SqliteTodoList.newInstance)));

  runApp(MyApp(todoList: todoList));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.todoList, Key? key}) : super(key: key);

  final TodoList todoList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo List', todoList: todoList),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.todoList})
      : super(key: key);

  final String title;
  final TodoList todoList;

  @override
  State<MyHomePage> createState() => _MyHomePageState(todoList);
}

class _MyHomePageState extends State<MyHomePage> {
  final TodoList todoList;
  final TextEditingController textEditingController = TextEditingController();

  _MyHomePageState(this.todoList);

  Future<void> _addItem(String text) async {
    await todoList.add(text);
    textEditingController.clear();
    setState(() {});
  }

  Widget futureCard(Item item) {
    return FutureBuilder<String>(
        future: item.title(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            snapshot.widgetFor(
                onData: (data) => Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 50,
                      color: Colors.white70,
                      child: Center(
                        child: Text(snapshot.data!),
                      ),
                    )),
                onProgress: () =>
                    const Center(child: CircularProgressIndicator()),
                onError: (error) => throw Exception(error)));
  }

  @override
  Widget build(BuildContext context) {
    final futureList = FutureBuilder<List<Item>>(
        future: todoList.items(),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) =>
            snapshot.widgetFor(
                onData: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("Empty"),
                    );
                  }
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: ScrollController(),
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          futureCard(data.elementAt(index)));
                },
                onProgress: () =>
                    const Center(child: CircularProgressIndicator()),
                onError: (error) => throw Exception(error)));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: futureList),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: textEditingController,
              onSubmitted: _addItem,
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
