import 'package:flutter/material.dart';
import 'package:flutter_todolist/async/extensions_async.dart';
import 'package:flutter_todolist/model/items/item.dart';
import 'package:flutter_todolist/model/lists/list.dart';

class TodoListWidget {
  static Widget newWidget(TodoList todoList) {
    return FutureBuilder<List<Item>>(
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
                          _cardWidget(data.elementAt(index)));
                },
                onProgress: () =>
                    const Center(child: CircularProgressIndicator()),
                onError: (error) => throw Exception(error)));
  }

  static Widget _cardWidget(Item item) {
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
}
