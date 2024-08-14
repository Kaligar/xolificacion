import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenModificarAlumno extends StatefulWidget {
  final int studentId;

  ScreenModificarAlumno({required this.studentId});

  @override
  _ScreenModificarAlumnoState createState() => _ScreenModificarAlumnoState();
}

class _ScreenModificarAlumnoState extends State<ScreenModificarAlumno> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _edadController;
  late TextEditingController _carreraController;
  late TextEditingController _grupoController;
  late TextEditingController _matriculaController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _edadController = TextEditingController();
    _carreraController = TextEditingController();
    _grupoController = TextEditingController();
    _matriculaController = TextEditingController();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Map<String, dynamic>? student = await dbHelper.getEstudianteById(widget.studentId);

    if (student != null) {
      setState(() {
        _nombreController.text = student['nombre'] ?? '';
        _edadController.text = student['edad']?.toString() ?? '';
        _carreraController.text = student['carrera'] ?? '';
        _grupoController.text = student['grupo'] ?? '';
        _matriculaController.text = student['matricula']?.toString() ?? '';
        _isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se encontró el estudiante'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateStudentData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        DatabaseHelper dbHelper = DatabaseHelper();
        int updatedRows = await dbHelper.updateEstudiante(
          widget.studentId,
          _nombreController.text,
          int.parse(_edadController.text),
          _carreraController.text,
          _grupoController.text,
          int.parse(_matriculaController.text),
        );

        if (updatedRows > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos actualizados correctamente')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo actualizar los datos del estudiante')),
          );
        }
      } catch (e) {
        print('Error al actualizar datos del estudiante: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error al actualizar los datos')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            'Modificar Alumno',
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
          : Padding(
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
                  int? edad = int.tryParse(value);
                  if (edad == null || edad <= 0) {
                    return 'Por favor ingrese una edad válida';
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
              _buildButton('Guardar Cambios', _updateStudentData),
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

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _carreraController.dispose();
    _grupoController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }
}