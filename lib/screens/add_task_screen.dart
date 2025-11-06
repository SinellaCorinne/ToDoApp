import 'package:flutter/material.dart';
import '../models/tasks.dart';
import '../services/api_services.dart';

class AddTaskScreen extends StatefulWidget {
  final VoidCallback onTaskAdded;

  const AddTaskScreen({required this.onTaskAdded, super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final api = ApiService();
  bool isLoading = false;

  void _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un titre")),
      );
      return;
    }

    setState(() => isLoading = true);
    final task = Task(
      id: 0,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      isDone: false,
    );
    final success = await api.addTask(task);
    setState(() => isLoading = false);

    if (success) {
      widget.onTaskAdded();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tâche ajoutée avec succès 🎉")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'ajout ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌸 AppBar douce et élégante
      appBar: AppBar(
        title: const Text(
          "Nouvelle tâche",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFD186BF),
      ),

      // 🌈 Dégradé de fond
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE5C6CC), Color(0xFFD186BF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Ajoute une nouvelle tâche 🌷",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 30),

                // 📝 Champ titre
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Titre",
                    labelStyle: const TextStyle(color: Color(0xFF6A1B9A)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFFD186BF), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFFD186BF), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🗒️ Champ description
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: const TextStyle(color: Color(0xFF6A1B9A)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFFD186BF), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFFD186BF), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 🔘 Bouton stylé
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton.icon(
                        onPressed: _saveTask,
                        icon: const Icon(Icons.save_alt, color: Colors.white),
                        label: const Text(
                          "Enregistrer",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD186BF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 6,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
