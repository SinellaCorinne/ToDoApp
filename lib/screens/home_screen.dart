import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import '../models/tasks.dart';
import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _tasks = api.getTasks();
    });
  }

  void _toggleTask(Task task) async {
    task.isDone = !task.isDone;
    await api.updateTask(task);
    _loadTasks();
  }

  void _deleteTask(int id) async {
    await api.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌸 AppBar élégant et doux
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mes Tâches",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFD186BF),
      ),

      // 🌈 Dégradé en fond pour garder ton style
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE5C6CC), Color(0xFFD186BF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Task>>(
          future: _tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:
                    CircularProgressIndicator(color: Colors.white),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Aucune tâche pour le moment 🌸",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final tasks = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    leading: GestureDetector(
                      onTap: () => _toggleTask(task),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: task.isDone
                              ? const Color(0xFFD186BF)
                              : Colors.white,
                          border: Border.all(
                            color: const Color(0xFFD186BF),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        width: 25,
                        height: 25,
                        child: task.isDone
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: task.isDone
                            ? Colors.grey
                            : const Color(0xFF6A1B9A),
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      style: TextStyle(
                        color: task.isDone
                            ? Colors.grey.shade400
                            : Colors.black54,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 28),
                      onPressed: () => _deleteTask(task.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      // ➕ Bouton flottant stylé
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 8,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(onTaskAdded: _loadTasks),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Color(0xFFD186BF),
          size: 30,
        ),
      ),
    );
  }
}
