import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    // Implement your login logic here (e.g., validate credentials, call an API)
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // Simulate successful login (replace with actual logic)
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Welcome!')));
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack( // Use Stack to position the image and content
        children: [
          // Green background
          Container(
            color: Colors.green,
            height: double.infinity, // Fills the entire screen
          ),
          // Login form with padding
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Replace "path/to/your/logo.png" with your actual logo path
                Image.asset(
                  'assets/img/utc.png',
                  height: 100.0, // Adjust logo size as needed
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
