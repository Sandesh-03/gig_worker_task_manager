import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gig_worker_task_manager/data/repositories/task_repository.dart';

import '../../data/datasources/task_remote_data_source.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';

final taskProvider = StreamProvider<List<TaskModel>>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return taskRepository.getTasks();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(taskRemoteDataSourceProvider));
});

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource();
});
