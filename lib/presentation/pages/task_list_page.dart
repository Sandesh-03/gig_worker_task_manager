import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'welcome_page.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String? userId;
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
  }

  void _deleteTask(String taskId) {
    _firestore.collection('tasks').doc(taskId).delete();
  }

  void _markTaskAsCompleted(String taskId) {
    _firestore.collection('tasks').doc(taskId).update({"isCompleted": true});
  }

  void _addOrUpdateTask({
    String? taskId,
    String? existingTitle,
    String? existingDescription,
    DateTime? existingDueDate,
    String? existingPriority,
  }) {
    TextEditingController titleController =
        TextEditingController(text: existingTitle ?? "");
    TextEditingController descriptionController =
        TextEditingController(text: existingDescription ?? "");
    DateTime selectedDate = existingDueDate ?? DateTime.now();
    String selectedPriority = existingPriority ?? "Normal";
    bool isUpdating = taskId != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(isUpdating ? "Update Task" : "Add Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(
                      "Due Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ["Low", "Normal", "High"].map((priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty) {
                    if (isUpdating) {
                      await _firestore.collection('tasks').doc(taskId).update({
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "dueDate": selectedDate.toIso8601String(),
                        "priority": selectedPriority,
                      });
                    } else {
                      await _firestore.collection('tasks').add({
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "dueDate": selectedDate.toIso8601String(),
                        "priority": selectedPriority,
                        "userId": userId,
                        "createdAt": FieldValue.serverTimestamp(),
                        "isCompleted": false,
                      });
                    }
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: Text(isUpdating ? "Update" : "Add"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.window, color: Colors.white70),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white70)),
                        const Text("My Tasks",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          _auth.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()));
                        },
                        icon: const Icon(Icons.more_horiz,
                            color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (query) => setState(() {}),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search tasks...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),

          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton("All"),
                _buildFilterButton("Today"),
                _buildFilterButton("Tomorrow"),
                _buildFilterButton("In Week"),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('tasks')
                  .where("userId", isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No tasks available!",
                          style: TextStyle(fontSize: 16)));
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                // Filter tasks based on due date
                List<DocumentSnapshot> filteredTasks = docs.where((doc) {
                  DateTime dueDate = DateTime.parse(doc["dueDate"]);
                  DateTime now = DateTime.now();
                  DateTime today = DateTime(now.year, now.month, now.day);
                  DateTime tomorrow = today.add(const Duration(days: 1));
                  DateTime nextWeek = today.add(const Duration(days: 7));

                  switch (_selectedFilter) {
                    case "Today":
                      return dueDate.isAtSameMomentAs(today);
                    case "Tomorrow":
                      return dueDate.isAtSameMomentAs(tomorrow);
                    case "In Week":
                      return dueDate.isAfter(today) &&
                          dueDate.isBefore(nextWeek);
                    default:
                      return true;
                  }
                }).toList();

                // Sort tasks by due date
                filteredTasks.sort((a, b) {
                  DateTime aDate = DateTime.parse(a["dueDate"]);
                  DateTime bDate = DateTime.parse(b["dueDate"]);
                  return aDate.compareTo(bDate);
                });

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: filteredTasks.map((doc) {
                    Map<String, dynamic> task =
                        doc.data() as Map<String, dynamic>;
                    String taskId = doc.id;
                    String title = task["title"];
                    String description = task["description"] ?? "";
                    String priority = task["priority"] ?? "Normal";
                    DateTime dueDate = DateTime.parse(task["dueDate"]);
                    bool isCompleted = task["isCompleted"] ?? false;

                    return Slidable(
                      key: ValueKey(taskId),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _addOrUpdateTask(
                                taskId: taskId,
                                existingTitle: title,
                                existingDescription: description,
                                existingDueDate: dueDate,
                                existingPriority: priority),
                            backgroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (_) => _deleteTask(taskId),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _getPriorityColor(priority),
                            ),
                            onPressed: () => _markTaskAsCompleted(taskId),
                          ),
                          title: Text(title),
                          subtitle: Text(
                              "Due: ${DateFormat('yyyy-MM-dd').format(dueDate)}\n$description"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _addOrUpdateTask(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedFilter == filter ? Colors.deepPurple : Colors.grey,
      ),
      child: Text(filter),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Low":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}
