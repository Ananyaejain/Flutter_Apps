import 'package:flutter/material.dart';
import '../../services/crud/task_service.dart';

typedef TaskCallBack = void Function(DatabaseTask task);

class TodoListView extends StatefulWidget {
  final List<DatabaseTask> tasks;
  final TaskCallBack onDeleteTask;

  TodoListView({
    super.key,
    required this.tasks,
    required this.onDeleteTask,
  });

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  late final TaskService _taskService;

  @override
  void initState() {
    _taskService = TaskService();
    super.initState();
  }

  void onChanged(bool? value, DatabaseTask task) {
    _taskService.checkBoxChanged(task: task);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.isChecked,
              onChanged: (value) => onChanged(value, task),
            ),
            title: Text(
              task.text,
              style: TextStyle(
                decoration: task.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationThickness: 3,
              ),
            ),
            trailing: IconButton(
              onPressed: () => widget.onDeleteTask(task),
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
