import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/main.dart';

import '../../../shared/models/task.dart';
import '../widgets/task_widget.dart';

// var tasks = [
//   Task.create(name: '🛍 Go Shopping'),
//   Task.create(name: '👨🏼‍💻 Code'),
//   Task.create(name: '🦮 Walk the dog'),
//   Task.create(name: '💪 Exercise'),
// ];

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
      valueListenable: base.dataStor.listenToTasks(),
      builder: (context, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();
        tasks.sort(((a, b) => a.createdAt.compareTo(b.createdAt)));
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 6),
                  child: const Text(
                    'What\'s up for Today?',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListTile(
                              title: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter task name'),
                                onSubmitted: (value) {
                                  Navigator.pop(context);
                                  DatePicker.showTimePicker(context,
                                      showSecondsColumn: false,
                                      showTitleActions: true,
                                      onConfirm: (date) {
                                    if (value.isNotEmpty) {
                                      // object
                                      var task = Task.create(
                                          name: value, createdAt: date);
                                      base.dataStor.addTask(task: task);
                                    }

                                    print('confirm $date');
                                  }, currentTime: DateTime.now());
                                },
                                autofocus: true,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  print('click click');
                                },
                                icon: const Icon(Icons.alarm),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              var task = tasks[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('This task was deleted',
                        style: TextStyle(
                          color: Colors.grey,
                        ))
                  ],
                ),
                onDismissed: (direction) {
                  base.dataStor.deleteTask(task: task);
                },
                key: Key(task.id),
                child: TaskWidget(
                  task: tasks[index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
