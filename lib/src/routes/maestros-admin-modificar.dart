import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'maestro-admin-modificar-state.dart';
class ScreenMaestrosAdminModificar extends StatefulWidget {
  @override
  _ScreenMaestrosAdminModificar createState() => _ScreenMaestrosAdminModificar();
}

class _ScreenMaestrosAdminModificar extends State<ScreenMaestrosAdminModificar> {
  List<Map<String, dynamic>> _maestros = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchmaestros();
  }

  Future<void> _fetchmaestros() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> maestros = await dbHelper.getMaestros();
    setState(() {
      _maestros = maestros;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maestros'),
        backgroundColor: Color(0XFF17A48B),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _maestros.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_maestros[index]['nombre']),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navegar a la siguiente pantalla con el ID del maestro
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenMaestrosAdminModificarState(maestroId: _maestros[index]['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Esta es una pantalla de ejemplo para mostrar los detalles del maestro
