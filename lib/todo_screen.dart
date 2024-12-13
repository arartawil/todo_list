import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();

  // Reference to the Realtime Database
  final DatabaseReference tasksRef = FirebaseDatabase.instance.ref('task');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Task',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final value = taskController.text.trim();
                    if (value.isNotEmpty) {
                      // Add task to Realtime Database
                      await tasksRef.push().set({
                        'task_name': value,
                        'times_start': DateTime.now().toIso8601String(),
                        'time_end':"2025"
                      });
                      taskController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Task cannot be empty')),
                      );
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: tasksRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('No tasks available.'));
                }

                // Convert Realtime Database snapshot to a Map
                final tasksMap = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>?) ?? {};
                final taskEntries = tasksMap.entries.toList();

                return ListView.builder(
                  itemCount: taskEntries.length,
                  itemBuilder: (context, index) {
                    final key = taskEntries[index].key;
                    final task = taskEntries[index].value['task_name'] ?? 'No task';

                    return ListTile(
                      title: Text(task),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // Delete task from Realtime Database
                          await tasksRef.child(key).remove();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
