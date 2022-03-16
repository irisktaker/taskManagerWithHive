import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/task.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController taskController = TextEditingController();
  @override
  void initState() {
    super.initState();
    taskController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 4),
                blurRadius: 10)
          ]),
      child: ListTile(
          leading: GestureDetector(
            onTap: () {
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save(); // to update database
            },
            child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: .8)),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
          title: widget.task.isCompleted
              ? Text(
                  taskController.text,
                  style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough),
                )
              : TextField(
                  controller: taskController,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (value) {
                    widget.task.name = value;
                    widget.task.save();
                  },
                ),
          trailing: Text(
            DateFormat('hh:mm a').format(widget.task.createdAt),
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          )),
    );
  }
}
