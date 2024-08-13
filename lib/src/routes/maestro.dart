import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'calificar.dart';

class MaestroScreen extends StatefulWidget {
  final int maestroId;

  const MaestroScreen({Key? key, this.maestroId = 0}) : super(key: key);

  @override
  _MaestroScreenState createState() => _MaestroScreenState();
}

class _MaestroScreenState extends State<MaestroScreen> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final dbHelper = DatabaseHelper();
    final maestro = await dbHelper.getMaestroById(widget.maestroId);
    final grupo = await dbHelper.ListaGrupos(widget.maestroId);
    return {'maestro': maestro, 'grupo': grupo};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF17A48B),
        title: Text(
          'Maestro',
          style: TextStyle(
            fontFamily: 'Hanuman',
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontró información'));
          } else {
            final maestro = snapshot.data!['maestro'];
            final grupo = snapshot.data!['grupo'] as List<Map<String, dynamic>>;
            return _buildMaestroContent(maestro, grupo);
          }
        },
      ),
    );
  }

  Widget _buildMaestroContent(Map<String, dynamic>? maestro, List<Map<String, dynamic>> grupo) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Salir',
              style: TextStyle(
                fontFamily: 'Hanuman',
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(30, 50),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Image.asset(
              'assets/img/perfil.png',
              width: 100,
            ),
          ),
          SizedBox(height: 16),
          Text('Nombre: ${maestro?['nombre'] ?? 'No disponible'}',
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 16),
          Text('Grupos asignados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          if (grupo.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: grupo.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Materia: ${grupo[index]['nameMateria'] ?? 'No disponible'}'),
                    subtitle: Text('grupo: ${grupo[index]['studentGroup'] ?? 'No disponible'}'),
                    trailing: ElevatedButton(
                      child: Text('calificar'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalificarScreen(
                              grupo: grupo[index]['studentGroup'],
                              materia: grupo[index]['nameMateria'],
                              grupo_id: grupo[index]['grupo_id'],
                              asignatura_id: grupo[index]['asignatura_id'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: Text('No hay grupos asignados', style: TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }
}