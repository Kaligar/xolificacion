import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class MaestroScreen extends StatefulWidget {
  //final int estudianteId;

  //EstudiantesScreen({required this.estudianteId});

  @override
  _MaestroScreenState createState() => _MaestroScreenState();
}

class _MaestroScreenState extends State<MaestroScreen> {
  Map<String, dynamic>? _Admin;
  bool _isLoading = false;

  @override
  //void initState() {
  //super.initState();
  //_loadEstudiante();
  //}

  //Future<void> _loadEstudiante() async {
  //DatabaseHelper dbHelper = DatabaseHelper();
  //final estudiante = await dbHelper.getEstudianteById(widget.estudianteId);
  //setState(() {
  //_estudiante = estudiante;
  //_isLoading = false;
  //});
  //}

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
              Text('Mestro', style: TextStyle(
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
      //: _estudiante == null
      //? Center(child: Text('No se encontró información del estudiante'))
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

          ],
        ),
      ),
    );
  }
}