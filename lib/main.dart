import 'package:flutter/material.dart';
import 'package:flutter_todolist/model/items/cached_list.dart';
import 'package:flutter_todolist/model/lists/list.dart';
import 'package:flutter_todolist/model/lists/memory_list.dart';
import 'package:flutter_todolist/model/lists/platform_list.dart';
import 'package:flutter_todolist/model/sqlite/sqlite_list.dart';
import 'package:flutter_todolist/widgets/todolist_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: TodoListWidget.newWidget(todoList)),
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
