import 'package:flutter/material.dart';
import 'package:its_done/main.dart';
import 'package:its_done/model/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kTaskListDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
  ),
);

const kListViewPadding = EdgeInsets.symmetric(
  horizontal: 30.0,
  vertical: 20.0,
);

const kMainContainerPadding = EdgeInsets.only(
  top: 60.0,
  left: 30.0,
  right: 30.0,
//  bottom: 30.0,
);

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final textController = TextEditingController();

  Widget buildBottomSheet(BuildContext context) => Container(
        color: const Color.fromARGB(255, 29, 90, 117),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              // const Text(
              //   'Add Task',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 35,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.lightBlue),
              // ),
              TextField(
                controller: textController,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add New Task',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                onSubmitted: (enteredText) {
                  setState(() {
                    ref
                        .read(tasksProvider)
                        .add(Task(name: textController.text));
                  });
                  textController.clear();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightBlue),
                ),
                onPressed: () {
                  setState(() {
                    ref
                        .read(tasksProvider)
                        .add(Task(name: textController.text));
                  });
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Task> taskList = ref.read(tasksProvider);

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: buildBottomSheet);
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          padding: kMainContainerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                child: Icon(
                  Icons.list,
                  size: 50.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'It\'s done',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '${taskList.length} tasks',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                    decoration: kTaskListDecoration,
                    child: ListView.builder(
                      padding: kListViewPadding,
                      itemCount: taskList.length,
                      prototypeItem: TaskTile(
                        taskTitle: taskList.first.name,
                      ),
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(taskList[index].uid),
                          direction: DismissDirection.endToStart,
                          // what to do after an item has been swiped away.
                          onDismissed: (direction) {
                            // Remove the item from the data source.
                            setState(() {
                              taskList.removeAt(index);
                            });
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: const Text(
                              'Delete',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),

                          child: TaskTile(
                            taskTitle: taskList[index].name,
                            taskComplete: taskList[index].isComplete,
                            callback: (isChecked) {
                              if (isChecked != null) {
                                setState(() {
                                  // isChecked
                                  //     ? context.read<Tasks>().decrement()
                                  //     : context.read<Tasks>().increment();
                                  taskList[index].toggleComplete();
                                });
                              }
                            },
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    this.taskTitle = '',
    this.taskComplete = false,
    this.callback,
  });
  final String taskTitle;
  final bool taskComplete;
  final void Function(bool?)? callback;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: taskComplete,
      activeColor: Colors.lightBlueAccent,
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration:
              taskComplete ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      onChanged: callback,
    );
  }
}
