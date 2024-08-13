import 'package:flutter/material.dart';
import 'package:untitled1/src/routes/grupos-admin-agregar.dart';
import 'package:untitled1/src/routes/grupos-admin-modificar.dart';
import 'package:untitled1/src/routes/grupos-admin-ver.dart';
import 'alumnos-admin-agregar.dart';
import 'alumnos-admin-modificar.dart';
import 'alumnos-admin-ver.dart';

class ScreenGruposAdmin extends StatefulWidget {


  @override
  _ScreenGruposAdmin createState() => _ScreenGruposAdmin();
}

class _ScreenGruposAdmin extends State<ScreenGruposAdmin> {
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
            'Grupos',
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
            _buildButton('ver lista', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenGruposAdminVer()),
              );
            }),
            SizedBox(height: 16),
            _buildButton('agregar', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenGruposAdminAgregar()),
              );
            }),
            SizedBox(height: 16),
            _buildButton('modificar', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenGruposAdminModificar()),
              );
            }),
            SizedBox(height: 32),
            Center(
              child: Image.asset(
                'assets/img/perfil.png',
                width: 100,
              ),
            ),
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