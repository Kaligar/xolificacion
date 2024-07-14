import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class AdminScreen extends StatefulWidget {
  final int adminId;

  AdminScreen({required this.adminId});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Map<String, dynamic>? _admin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  Future<void> _loadAdmin() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    final admin = await dbHelper.getAdminById(widget.adminId);
    setState(() {
      _admin = admin;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Administrador', style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Color(0xFFFFFFFF),
              )),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _admin == null
          ? Center(child: Text('No se encontró información del administrador'))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Salir', style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Color(0xFF000000),
              )),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(30, 50),
              ),
            ),
            SizedBox(height: 8),
            Image.asset(
              'assets/img/perfil.png',
              width: 100,
            ),
            SizedBox(height: 16),
            Text('Nombre: ${_admin!['nombre']}'),
            Text('ID: ${_admin!['admin_id']}'),
            // Add more admin information as needed
          ],
        ),
      ),
    );
  }
}