import 'package:flutter/material.dart';
import 'package:untitled1/src/routes/alumnos-admin-agregar.dart';
import 'package:untitled1/src/routes/alumnos-admin-modificar.dart';
import 'package:untitled1/src/routes/alumnos-admin-ver.dart';


class ScreenAlumnosAdmin extends StatefulWidget {


  @override
  _ScreenAlumnosAdmin createState() => _ScreenAlumnosAdmin();
}

class _ScreenAlumnosAdmin extends State<ScreenAlumnosAdmin> {

  @override
  void initState() {
    super.initState();
    // Inicialización si es necesaria
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
            'Alumno',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButton('Salir', () {
              Navigator.of(context).pop();
            }),
            SizedBox(height: 16),
            _buildButton('Ver lista', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenAlumnosAdminVer()),
              );
            }),
            SizedBox(height: 16),
            _buildButton('Agregar', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenAlumnosAdminAgregar()),
              );
            }),
            SizedBox(height: 16),
            _buildButton('Modificar', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenAlumnosAdminModificar()),
              );
            }),
            SizedBox(height: 32),

            // Agrega más información del administrador si es necesario
          ],
        ),
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
          fontSize: 30,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}