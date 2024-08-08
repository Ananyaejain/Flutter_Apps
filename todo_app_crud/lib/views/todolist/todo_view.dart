import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_crud/constants/routes.dart';
import 'package:todo_app_crud/enums/menu_action.dart';
import 'package:todo_app_crud/services/crud/task_service.dart';
import 'package:todo_app_crud/utils/create_new_task_dialog.dart';
import 'package:todo_app_crud/utils/logout_dialog.dart';
import 'package:todo_app_crud/views/todolist/todo_list_view.dart';

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView> {
  //List toDoList = [];
  //late TextEditingController _controller;
  late final TaskService _taskService;
  String get userEmail => FirebaseAuth.instance.currentUser!.email!;

  @override
  void initState() {
    //_controller = TextEditingController();
    _taskService = TaskService();
    super.initState();
  }

  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
  //
  // void delTask(int index) {
  //   setState(() {
  //     toDoList.removeAt(index);
  //   });
  // }

  // void checkBoxChanged(bool? value, int index) {
  //   setState(() {
  //     toDoList[index][1] = !toDoList[index][1];
  //   });
  // }
  //
  // void onSaved() {
  //   setState(() {
  //     toDoList.add([_controller.text, false]);
  //     _controller.clear();
  //   });
  //   Navigator.of(context).pop();
  // }
  //
  // void onCancel() {
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logOut:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      final user = FirebaseAuth.instance;
                      user.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logOut,
                    child: Text('Logout'),
                  )
                ];
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed(createNewTaskRoute),
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: _taskService.createOrGetUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _taskService.allTasks,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allTasks = snapshot.data as List<DatabaseTask>;
                          return TodoListView(
                            tasks: allTasks,
                            onDeleteTask: (task) async {
                              await _taskService.deleteTask(taskId: task.id);
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
