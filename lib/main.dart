import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/app/data/hive_data_store.dart';
import 'package:task_manager/app/shared/models/task.dart';
import 'app/models/home/views/home_view.dart';

Future<void> main() async {
  await Hive.initFlutter();

  // register adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  // open Box - box name 'tasks' type is Task
  Box<Task> box = await Hive.openBox<Task>('tasks');

  // delete data from the previous day
  box.values.forEach((task) {
    if (task.createdAt.day != DateTime.now().day) {
      box.delete(task.id);
    }
  });

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({required this.child}) : super(child: child);
  final HiveDataStor dataStor = HiveDataStor();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError("Could not find ancestor widget of type BaseWidget");
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const HomeView(),
    );
  }
}
