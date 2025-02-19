import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gig_worker_task_manager/data/models/task_model.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId) // Using UID instead of email
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    });
  }
}
