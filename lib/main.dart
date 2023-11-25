//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'model/task.dart';
import 'screens/tasks_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Generate comments for this project
final tasksProvider = StateNotifierProvider<TaskListState, List<Task>>((ref) {
  return TaskListState();
});

class TaskListState extends StateNotifier<List<Task>> {
//  TaskListState() : super(const []);
  List<Task> taskList = [];

  TaskListState() : super(const []) {
    addTask('Choose Edinburgh Accommodation');
    addTask('Book Edinburgh Accommodation');
    addTask('Book John and Jane for Sunday Lunch');
    addTask('Book car in for tyre change');

    state = taskList;
  }

  void addTask(String newTaskName) => taskList.add(Task(name: newTaskName));
  void deleteTask(int index) => taskList.removeAt(index);
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: TasksScreen(),
    );
  }
}
