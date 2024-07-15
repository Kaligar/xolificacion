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
  Map<String, dynamic>? _maestro;
  List<Map<String, dynamic>>? _grupo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaestro();
    _loadGrupo();
  }

  Future<void> _loadMaestro() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      final maestro = await dbHelper.getMaestroById(widget.maestroId);
      setState(() {
        _maestro = maestro;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading maestro: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGrupo() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      final grupo = await dbHelper.ListaGrupos(widget.maestroId);
      setState(() {
        _grupo = grupo;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar grupo: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _maestro == null
          ? Center(child: Text('No se encontró información del maestro'))
          : SingleChildScrollView(
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
            Text('Nombre: ${_maestro!['nombre'] ?? 'No disponible'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Grupos asignados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            if (_grupo != null && _grupo!.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _grupo!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Materia: ${_grupo![index]['nameMateria'] ?? 'No disponible'}'),
                      subtitle: Text('grupo: ${_grupo![index]['studentGroup'] ?? 'No disponible'}'),
                      trailing: ElevatedButton(
                        child: Text('calificacar'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalificarScreen(
                                grupo: _grupo![index]['studentGroup'],
                                materia: _grupo![index]['nameMateria'],
                                asignatura_id: _grupo![index]['asignatura_id'],
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
      ),
    );
  }
}