import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenAlumnosAdminAgregar extends StatefulWidget {
  @override
  _ScreenAlumnosAdminAgregarState createState() => _ScreenAlumnosAdminAgregarState();
}

class _ScreenAlumnosAdminAgregarState extends State<ScreenAlumnosAdminAgregar> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _carreraController = TextEditingController();
  final _grupoController = TextEditingController();
  final _matriculaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _carreraController.dispose();
    _grupoController.dispose();
    _matriculaController.dispose();
    super.dispose();
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
            'Agregar Alumno',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la edad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carreraController,
                decoration: InputDecoration(labelText: 'Carrera'),
              ),
              TextFormField(
                controller: _grupoController,
                decoration: InputDecoration(labelText: 'Grupo'),
              ),
              TextFormField(
                controller: _matriculaController,
                decoration: InputDecoration(labelText: 'Matrícula'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la matrícula';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildButton('Agregar Alumno', _agregarAlumno),
              SizedBox(height: 16),
              _buildButton('Salir', () {
                Navigator.of(context).pop();
              }),
            ],
          ),
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

  void _agregarAlumno() async {
    if (_formKey.currentState!.validate()) {
      try {
        DatabaseHelper dbHelper = DatabaseHelper();
        int result = await dbHelper.insertEstudiante({
          'nombre': _nombreController.text,
          'edad': int.parse(_edadController.text),
          'carrera': _carreraController.text,
          'grupo': _grupoController.text,
          'matricula': int.parse(_matriculaController.text),
        });

        if (result != -1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Alumno agregado correctamente')),
          );
          // Limpiar los campos después de agregar
          _nombreController.clear();
          _edadController.clear();
          _carreraController.clear();
          _grupoController.clear();
          _matriculaController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar alumno')),
          );
        }
      } catch (e) {
        print('Error al agregar alumno: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar alumno')),
        );
      }
    }
  }
}