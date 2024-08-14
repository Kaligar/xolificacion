  import 'package:flutter/material.dart';
  import '../data/database_helper.dart';

  class ScreenAlumnosAdminVer extends StatefulWidget {
    @override
    _ScreenAlumnosAdminVerState createState() => _ScreenAlumnosAdminVerState();
  }

  class _ScreenAlumnosAdminVerState extends State<ScreenAlumnosAdminVer> {
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

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0XFF17A48B),
            title: Text(
              'Ver Alumnos',
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
            return ListTile(
              title: Text(_estudiantes[index]['nombre']),
              subtitle: Text('Edad: ${_estudiantes[index]['edad']}'),
              trailing: Text(_estudiantes[index]['carrera'] ?? 'No disponible'),
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
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }