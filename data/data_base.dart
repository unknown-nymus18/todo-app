import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List todoList = [];

  final _myBox = Hive.box('myBox');

  void createInitialData() {
    todoList = [
      ['Follow Unknown_nymus', false],
      ['Do exercise', true],
    ];
  }

  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

  void updateDataBase() {
    _myBox.put('TODOLIST', todoList);
  }

  ValueListenable listenable() {
    return _myBox.listenable();
  }

  void deleteData(int index) {
    todoList.removeAt(index);
    updateDataBase();
  }

  void addData(String task) {
    todoList.add([task, false]);
    updateDataBase();
  }
}
