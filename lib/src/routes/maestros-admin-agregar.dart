import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenMaestrosAdminAgregar extends StatefulWidget {
  @override
  _ScreenMaestrosAdminAgregarState createState() => _ScreenMaestrosAdminAgregarState();
}

class _ScreenMaestrosAdminAgregarState extends State<ScreenMaestrosAdminAgregar> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Maestro'),
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
                decoration: InputDecoration(labelText: 'Nombre del Maestro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del maestro';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Agregar Maestro'),
                onPressed: _agregarMaestro,
                style: ElevatedButton.styleFrom(
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarMaestro() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _databaseHelper.insertMaestro({'nombre': _nombreController.text});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maestro agregado exitosamente')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar el maestro: $e')),
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