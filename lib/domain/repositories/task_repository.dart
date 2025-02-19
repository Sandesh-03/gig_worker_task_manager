import 'package:gig_worker_task_manager/domain/entities/task.dart';

import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Stream<List<TaskModel>> getTasks();
}
