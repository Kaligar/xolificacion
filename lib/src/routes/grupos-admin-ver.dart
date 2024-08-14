import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class ScreenGruposAdminVer extends StatefulWidget {
  @override
  _ScreenGruposAdminVer createState() => _ScreenGruposAdminVer();
}

class _ScreenGruposAdminVer extends State<ScreenGruposAdminVer> {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFF17A48B),
          title: Text(
            'Ver Grupos',
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
        itemCount: _grupos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_grupos[index]['nombre']),

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
