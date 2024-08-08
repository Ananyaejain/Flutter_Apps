import 'package:flutter/material.dart';
import '../../services/crud/task_service.dart';

typedef TaskCallBack = void Function(DatabaseTask task);

class TodoTile extends StatelessWidget {
  final bool isTaskCompleted;
  final TaskCallBack onChanged;
  final String taskName;
  final TaskCallBack delTask;

  TodoTile({
    super.key,
    required this.isTaskCompleted,
    required this.onChanged,
    required this.taskName,
    required this.delTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(
            value: isTaskCompleted,
            onChanged: onChanged as Function(bool?)?,
          ),
          Text(
            taskName,
            style: TextStyle(
              decoration: isTaskCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationThickness: 3,
            ),
          ),
          const SizedBox(
            width: 240,
          ),
          IconButton(
            onPressed: delTask as VoidCallback,
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
