import 'package:flutter/material.dart';
import 'package:gig_worker_task_manager/domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            // Implement task completion toggle
          },
        ),
        onTap: () {
          // Navigate to task details or edit screen
        },
      ),
    );
  }
}