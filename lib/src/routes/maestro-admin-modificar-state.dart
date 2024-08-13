import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenMaestrosAdminModificarState extends StatefulWidget {
  final int maestroId;

  ScreenMaestrosAdminModificarState({required this.maestroId});

  @override
  _ScreenMaestrosAdminModificarState createState() => _ScreenMaestrosAdminModificarState();
}

class _ScreenMaestrosAdminModificarState extends State<ScreenMaestrosAdminModificarState> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaestroData();
  }

  Future<void> _loadMaestroData() async {
    final maestro = await _databaseHelper.getMaestroById(widget.maestroId);
    if (maestro != null) {
      setState(() {
        _nombreController.text = maestro['nombre'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Maestro'),
        backgroundColor: Color(0XFF17A48B),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                child: Text('Actualizar Maestro'),
                onPressed: _actualizarMaestro,
                style: ElevatedButton.styleFrom(

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _actualizarMaestro() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _databaseHelper.updateMaestro(widget.maestroId, _nombreController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maestro actualizado exitosamente')),
        );
        Navigator.pop(context, true);  // Retorna true para indicar que se actualizó
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el maestro: $e')),
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