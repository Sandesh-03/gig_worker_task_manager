import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';
import '../../domain/entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TaskRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> addTask(Task task) async {
    final String? userId = _auth.currentUser?.uid; // Use UID instead of email
    if (userId != null) {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        userId: userId, // Ensure UID is used
        createdAt: task.createdAt,
      );
      await _remoteDataSource.addTask(taskModel);
    } else {
      throw Exception("User not authenticated");
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    final String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        userId: userId,
        createdAt: task.createdAt,
      );
      await _remoteDataSource.updateTask(taskModel);
    } else {
      throw Exception("User not authenticated");
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await _remoteDataSource.deleteTask(id);
  }

  @override
  Stream<List<TaskModel>> getTasks() {
    final String? userId = _auth.currentUser?.uid; // Use UID instead of email
    if (userId == null) {
      return Stream.error("User not authenticated"); // Return an error instead of an empty stream
    }

    return _remoteDataSource.getTasks(userId).map((taskModels) {
      return taskModels.map((taskModel) => TaskModel(
        id: taskModel.id,
        title: taskModel.title,
        description: taskModel.description,
        dueDate: taskModel.dueDate,
        priority: taskModel.priority,
        isCompleted: taskModel.isCompleted,
        userId: taskModel.userId,
        createdAt: taskModel.createdAt,
      )).toList();
    });
  }
}
