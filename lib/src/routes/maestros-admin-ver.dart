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
    _fetchMaestros();
  }

  Future<void> _fetchMaestros() async {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFF17A48B),
          title: Text(
            'Ver Maestros',
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
          : ListView.builder(
        itemCount: _maestros.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_maestros[index]['nombre']),
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
}
