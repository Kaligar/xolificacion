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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFF17A48B),
          title: Text(
            'Modificar Alumnos',
            style: TextStyle(
              fontFamily: 'Hanuman',
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
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
                  _buildButton('Ver', () => _navigateToNextScreen(_estudiantes[index]['id'])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Hanuman',
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}