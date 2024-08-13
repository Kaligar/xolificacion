import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenModificarGrupo extends StatefulWidget {
  final Map<String, dynamic> grupo;

  ScreenModificarGrupo({required this.grupo});

  @override
  _ScreenModificarGrupoState createState() => _ScreenModificarGrupoState();
}

class _ScreenModificarGrupoState extends State<ScreenModificarGrupo> {
  late TextEditingController _nombreController;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.grupo['nombre']);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    try {
      await _dbHelper.updateGrupo(widget.grupo['id'], _nombreController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo actualizado correctamente')),
      );
      Navigator.pop(context, true); // Retorna true para indicar que se realizó una actualización
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el grupo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Grupo'),
        backgroundColor: Color(0XFF17A48B),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ID del Grupo: ${widget.grupo['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Grupo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Guardar Cambios'),
              onPressed: _guardarCambios,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}