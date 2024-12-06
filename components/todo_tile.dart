import 'package:flutter/material.dart';
import 'package:todo_app/data/data_base.dart';

class TodoTile extends StatefulWidget {
  final DataBase db;
  final int index;
  const TodoTile({super.key, required this.db, required this.index});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  @override
  Widget build(BuildContext context) {
    final todo = widget.db.todoList[widget.index][0];
    final isDone = widget.db.todoList[widget.index][1];

    void btnClicked(value) {
      setState(() {
        widget.db.todoList[widget.index][1] = value;
        widget.db.updateDataBase();
      });
    }

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              todo,
              style: TextStyle(
                fontSize: 16,
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.black,
            value: isDone,
            onChanged: (value) => btnClicked(value),
          ),
        ],
      ),
    );
  }
}
