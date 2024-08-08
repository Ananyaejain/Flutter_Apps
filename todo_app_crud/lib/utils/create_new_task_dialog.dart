import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_crud/constants/routes.dart';
import 'package:todo_app_crud/services/crud/task_service.dart';

class CreateNewTaskDialog extends StatefulWidget {
  const CreateNewTaskDialog({super.key});

  @override
  State<CreateNewTaskDialog> createState() => _CreateNewTaskDialogState();
}

class _CreateNewTaskDialogState extends State<CreateNewTaskDialog> {
  late final TextEditingController _textController;
  late final TaskService _taskService;
  DatabaseTask? _task;

  @override
  void initState() {
    _textController = TextEditingController();
    _taskService = TaskService();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _textControllerListener() async{
    final task = _task;
    final text = _textController.text;
    if (task != null) {
      await _taskService.updateTask(
        task: task,
        text: text,
      );
    }
  }

  void setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseTask> createNewTask(BuildContext context) async {
    final currUser = FirebaseAuth.instance.currentUser!;
    final email = currUser.email!;
    print(currUser.email);
    final owner = await _taskService.fetchUser(email: email);
    final newTask = await _taskService.createTask(owner: owner);
    _task = newTask;
    print(_task!.id);
    return newTask;
  }

  void onSaved() {
    final task = _task;
    final text = _textController.text;
    if (task != null && text.isNotEmpty) {
      _taskService.updateTask(
        task: task,
        text: text,
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        toDoRoute,
        (predicate) => false,
      );
    } else {
      print('ERROR');
    }
  }

  void onCancel() {
    final task = _task;
    if (task != null) {
      _taskService.deleteTask(taskId: task.id);
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      toDoRoute,
      (predicate) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: FutureBuilder(
        future: createNewTask(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              setupTextControllerListener();
              return Column(
                children: [
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your task here!!',
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: onSaved,
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
