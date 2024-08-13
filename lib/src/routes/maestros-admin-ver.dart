import 'package:flutter/material.dart';
import '../data/database_helper.dart';
class ScreenMaestrosAdminVer extends StatefulWidget {


  @override
  _ScreenMaestrosAdminVer createState() => _ScreenMaestrosAdminVer();
}

class _ScreenMaestrosAdminVer extends State<ScreenMaestrosAdminVer> {
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
        title: Text('Estudiantes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _maestros.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_maestros[index]['nombre']),
            subtitle: Text('Edad: ${_maestros[index]['edad']}'),
            trailing: Text(_maestros[index]['carrera'] ?? 'No disponible'),
          );
        },
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