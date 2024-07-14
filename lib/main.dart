import 'package:flutter/material.dart';
import 'package:untitled1/src/routes/maestro.dart';
import 'src/data/database_helper.dart';
import 'src/routes/alumno.dart';
import 'src/routes/admin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/alumno': (context) => EstudiantesScreen(estudianteId: ModalRoute.of(context)!.settings.arguments as int),
        '/maestro': (context) => MaestroScreen(),
        '/admin': (context) => AdminScreen(),
      },
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? user = await dbHelper.getUser(username, password);

    if (user != null) {
      String role = user['role'] as String;
      int? id = user['${role}_id'] as int?;

      if (id != null) {
        switch (role) {
          case 'estudiante':
            Navigator.pushNamed(context, '/alumno', arguments: id);
            break;
          case 'maestro':
            Navigator.pushNamed(context, '/maestro');
            break;
          case 'admin':
            Navigator.pushNamed(context, '/admin');
            break;
          default:
            _showMessage('Role not recognized');
        }
      } else {
        _showMessage('Error: No ID associated with this user');
      }
    } else {
      _showMessage('Invalid credentials');
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE3E3E4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/img/UTCLOGO.png',
              width: 95,
              height: 50,
            ),
            Text('Xolificaciones',
                style: TextStyle(
                  fontFamily: 'Hanuman',
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF181818),
                )
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF17A48B),
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              _buildInputField('Usuario', _usernameController),
              SizedBox(height: 20),
              _buildInputField('Contraseña', _passwordController, isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Ingresar',
                    style: TextStyle(
                      fontFamily: 'Hanuman',
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF000000),
                    )
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(30, 50),
                ),
              ),
              SizedBox(height: 30),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _message.contains('successful') ? Colors.white : Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Hanuman',
            fontSize: 40,
            fontWeight: FontWeight.w300,
            color: Color(0xFFFFFFFF),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: isPassword,
        ),
      ],
    );
  }
}