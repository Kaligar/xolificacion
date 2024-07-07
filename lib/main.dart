import 'package:flutter/material.dart';
import 'package:untitled1/src/routes/maestro.dart';
import 'src/data/database_helper.dart';
import 'src/routes/alumno.dart'; // Añada esta línea al inicio del archivo
import 'src/routes/admin.dart';

//funcion pricipal, inicializacio de la aplicacion
void main() {
  runApp(MyApp());
}

// class que no cambia por  StatelessWidget
// loginScreen pantalla de inicio
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/src/routes/alumno.dart': (context) => EstudiantesScreen(estudianteId: ModalRoute.of(context)!.settings.arguments as int),
      },
      home: LoginScreen(),
    );
  }
}

//creamos un widget tipo StatefulWidget que puede cambiar su estado
//createState(), que devuelve una instancia la _LoginScreenState
//gestion de cambios (actualizacion de campos)
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//controladores de texto
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  // Obtiene los valores
  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? user = await dbHelper.getUser(username, password);

    if (user != null) {
      String role = user['role'] as String;
      int? estudianteId = user['estudiante_id'] as int?;

      switch (role) {
        case 'estudiante':
          if (estudianteId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EstudiantesScreen(estudianteId: estudianteId),
              ),
            );
          } else {
            setState(() {
              _message = 'Error: No student ID associated with this user';
            });
          }
          break;
          case 'maestro':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaestroScreen(),
              
            ),

          );
          break;
        case 'admin':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminScreen(),
            ),
          );
          break;
        default:
          setState(() {
            _message = 'Role not recognized';
          });
      }
    } else {
      setState(() {
        _message = 'Invalid credentials';
      });
    }
  }



  //construccion de la interface usuario
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
            ), // Añade el texto que desees
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF17A48B), // Color verde en hexadecimal
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(

            children: <Widget>[

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usuario',
                  style: TextStyle(
                    fontFamily: 'Hanuman',
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(1),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Contraseña',
                  style: TextStyle(
                    fontFamily: 'Hanuman',
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              TextField(

                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white.withOpacity(1),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(

                onPressed: _login,
                child: Text('Ingresar', style: TextStyle(
                  fontFamily: 'Hanuman',
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF000000),
                )),
                style:
                ElevatedButton.styleFrom(

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
}