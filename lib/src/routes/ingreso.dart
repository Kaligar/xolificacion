import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class EstudiantesScreen extends StatefulWidget {
  final int estudianteId;

  EstudiantesScreen({required this.estudianteId});

  @override
  _EstudiantesScreenState createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  Map<String, dynamic>? _estudiante;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEstudiante();
  }

  Future<void> _loadEstudiante() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final estudiante = await dbHelper.getEstudianteById(widget.estudianteId);
    setState(() {
      _estudiante = estudiante;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFF17A48B),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('UTC', style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Color(0xFFFFFFFF),
              )),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _estudiante == null
          ? Center(child: Text('No se encontró información del estudiante'))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);

                print('');
              },
              child: Text('salir', style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Color(0xFF000000),
              )),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(30, 50),
              ),
            ),
            SizedBox(height: 8),
            Image.asset(
              'assets/img/perfil.png',
              width: 100,
            ),
            Text('Nombre: ${_estudiante!['nombre']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Edad: ${_estudiante!['edad']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Carrera: ${_estudiante!['carrera']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Grupo: ${_estudiante!['grupo']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Matrícula: ${_estudiante!['matricula']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes definir lo que quieres que haga el botón
                print('Botón presionado');
              },
              child: Text('calificaciones', style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Color(0xFF000000),
              )),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(30, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}