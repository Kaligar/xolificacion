import 'package:flutter/material.dart';
import '../data/database_helper.dart'; // Asegúrate de importar correctamente tu DatabaseHelper

class ScreenGruposAdminAgregar extends StatefulWidget {
  @override
  _ScreenGruposAdminAgregarState createState() => _ScreenGruposAdminAgregarState();
}

class _ScreenGruposAdminAgregarState extends State<ScreenGruposAdminAgregar> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Grupo'),
        backgroundColor: Color(0XFF17A48B),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Grupo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre para el grupo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Agregar Grupo'),
                onPressed: _agregarGrupo,
                style: ElevatedButton.styleFrom(
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarGrupo() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _databaseHelper.insertGrupo({'nombre': _nombreController.text});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo agregado exitosamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar el grupo: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }
}