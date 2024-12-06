import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/components/blur.dart';
import 'package:todo_app/components/todo_tile.dart';
import 'package:todo_app/data/data_base.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myBox = Hive.box('myBox');
  DataBase db = DataBase();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if (myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void addTask() {
    db.addData(_textEditingController.text);
    _textEditingController.clear();
    Navigator.pop(context);
  }

  void deleteTask(index) {
    db.deleteData(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TODO APP"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Blur(
                    sigmaX: 5,
                    sigmaY: 5,
                    child: AlertDialog(
                      title: const Text("ADD A TASK"),
                      content: SizedBox(
                        child: TextField(
                          controller: _textEditingController,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _textEditingController.clear();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: addTask,
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: db.listenable(),
        builder: (context, child) {
          return ListView.builder(
            itemCount: db.todoList.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      HapticFeedback.selectionClick();
                      return Blur(
                        sigmaX: 5,
                        sigmaY: 5,
                        child: AlertDialog(
                          title: const Text("DELETE TASK"),
                          content: const Text(
                              "Are you sure you want to delete this task?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _textEditingController.clear();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () => deleteTask(i),
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: TodoTile(db: db, index: i),
              );
            },
          );
        },
      ),
    );
  }
}
