import 'package:flutter/material.dart';
import '../../services/crud/task_service.dart';

typedef TaskCallBack = void Function(DatabaseTask task);

class TodoListView extends StatelessWidget {
  final List<DatabaseTask> tasks;
  final TaskCallBack onDeleteTask;
  final TaskCallBack onChanged;

  TodoListView({
    super.key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.isChecked,
              onChanged: onChanged as Function(bool?)?,
            ),
            title: Text(task.text),
            trailing: IconButton(
              onPressed: onDeleteTask as VoidCallback,
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
