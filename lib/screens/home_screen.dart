import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/profile.dart';
import 'package:todo_app/screens/task_details.dart';
import '../models/tasks.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Liste locale de tâches pour le Livrable 1
  List<Task> _tasks = [
    Task(id: 1, title: "Réviser Flutter 🚀", description: "Terminer l'intégration des écrans pour le projet.", isDone: false),
    Task(id: 2, title: "Acheter des fleurs 🌷", description: "Passer chez le fleuriste avant de rentrer.", isDone: true),
  ];

  void _loadTasks() {
    setState(() {});
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mes Tâches",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFFD186BF),
        // 👤 Ajout du bouton Profil dans l'AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE5C6CC), Color(0xFFD186BF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _tasks.isEmpty
            ? const Center(
          child: Text("Aucune tâche 🌸", style: TextStyle(color: Colors.white, fontSize: 18)),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return GestureDetector(
              // 🔍 Lien vers la page de Détails au clic sur la carte
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
              ),
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white.withOpacity(0.9),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  leading: GestureDetector(
                    onTap: () => _toggleTask(task),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: task.isDone ? const Color(0xFFD186BF) : Colors.white,
                        border: Border.all(color: const Color(0xFFD186BF), width: 2),
                        shape: BoxShape.circle,
                      ),
                      width: 25,
                      height: 25,
                      child: task.isDone ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                    ),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: task.isDone ? Colors.grey : const Color(0xFF6A1B9A),
                      decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: const Text("Priorité: Moyenne", style: TextStyle(color: Colors.orange, fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddTaskScreen(onTaskAdded: _loadTasks)),
        ),
        child: const Icon(Icons.add, color: Color(0xFFD186BF), size: 30),
      ),
    );
  }
}