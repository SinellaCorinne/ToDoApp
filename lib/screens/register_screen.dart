import 'package:flutter/material.dart';
import 'package:todo_app/screens/login_screen.dart';
import '../services/api_services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final api = ApiService();

  bool isLoading = false;

  void _register() async {
    setState(() => isLoading = true);
    final result = await api.register(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => isLoading = false);

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Inscription réussie")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Échec de l'inscription")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🩵 Dégradé harmonieux
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE5C6CC), Color(0xFFD186BF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Logo ou icône circulaire
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: const Icon(Icons.person_add_alt_1_rounded,
                        size: 50, color: Color(0xFFD186BF)),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Créer un compte",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔹 Champ Username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFFD186BF)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nom d'utilisateur",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Champ Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFFD186BF)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Mot de passe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Bouton d’inscription
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFD186BF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),

                  const SizedBox(height: 20),

                  // 🔹 Lien vers connexion
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    ),
                    child: const Text(
                      "Déjà un compte ? Se connecter",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
