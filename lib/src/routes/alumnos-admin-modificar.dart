import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'alumnos-admin-modificar-state.dart';
class ScreenAlumnosAdminModificar extends StatefulWidget {
  @override
  _ScreenAlumnosAdminModificar createState() => _ScreenAlumnosAdminModificar();
}

class _ScreenAlumnosAdminModificar extends State<ScreenAlumnosAdminModificar> {
  List<Map<String, dynamic>> _estudiantes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEstudiantes();
  }

  Future<void> _fetchEstudiantes() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> estudiantes = await dbHelper.getEstudiantes();
    setState(() {
      _estudiantes = estudiantes;
      _isLoading = false;
    });
  }

  void _navigateToNextScreen(int studentId) {
    Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => ScreenModificarAlumno(studentId: studentId))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _estudiantes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_estudiantes[index]['nombre']),
              subtitle: Text('Edad: ${_estudiantes[index]['edad']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_estudiantes[index]['carrera'] ?? 'No disponible'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _navigateToNextScreen(_estudiantes[index]['id']),
                    child: Text('Ver'),
                    style: ElevatedButton.styleFrom(
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}