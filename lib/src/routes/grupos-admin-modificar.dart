import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'grupos-admin-modificar-state.dart';

class ScreenGruposAdminModificar extends StatefulWidget {
  @override
  _ScreenGruposAdminModificar createState() => _ScreenGruposAdminModificar();
}

class _ScreenGruposAdminModificar extends State<ScreenGruposAdminModificar> {
  List<Map<String, dynamic>> _grupos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrupos();
  }

  Future<void> _fetchGrupos() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> grupos = await dbHelper.getGrupos();
    setState(() {
      _grupos = grupos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos'),
        backgroundColor: Color(0XFF17A48B),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _grupos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(_grupos[index]['nombre']),
              trailing: ElevatedButton(
                child: Text('Modificar'),
                onPressed: () {
                  // Navegar a la pantalla de modificación
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenModificarGrupo(grupo: _grupos[index]),
                    ),
                  ).then((_) => _fetchGrupos()); // Actualizar la lista después de modificar
                },
                style: ElevatedButton.styleFrom(

                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
