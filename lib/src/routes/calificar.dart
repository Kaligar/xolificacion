import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class CalificarScreen extends StatefulWidget {
  final String grupo;
  final String materia;
  final int grupo_id;
  final int asignatura_id;

  const CalificarScreen({
    Key? key,
    required this.grupo,
    required this.materia,
    required this.grupo_id,
    required this.asignatura_id
  }) : super(key: key);

  @override
  _CalificarScreenState createState() => _CalificarScreenState();
}

class _CalificarScreenState extends State<CalificarScreen> {
  late Future<List<Map<String, dynamic>>> _estudiantesFuture;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _estudiantesFuture = _cargarEstudiantes();
  }

  Future<List<Map<String, dynamic>>> _cargarEstudiantes() async {
    await dbHelper.verificarTablaCalificaciones();
    return await dbHelper.cargarEstudiantes(widget.grupo_id);
  }

  Future<void> _guardarCalificaciones(List<Map<String, dynamic>> estudiantes, List<TextEditingController> controllers) async {
    try {
      print('Iniciando guardado de calificaciones...');
      for (int i = 0; i < estudiantes.length; i++) {
        var estudiante = estudiantes[i];
        var calificacion = double.tryParse(controllers[i].text);
        if (calificacion != null) {
          print('Intentando guardar calificación para estudiante ID: ${estudiante['id']}, Grupo ID: ${widget.grupo_id}, Calificación: $calificacion');
          await dbHelper.insertCalificacion({
            'estudiante_id': estudiante['id'],
            'asignatura_id': widget.asignatura_id, // This might need to be adjusted depending on how you're handling subjects
            'calificacion': calificacion,
          });
          await dbHelper.verificarCalificacion(estudiante[8], widget.asignatura_id);
          print('Calificación guardada con éxito');
        } else {
          print('Estudiante ID: ${estudiante['id']} no tiene calificación válida');
        }
      }
      print('Proceso de guardado completado');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calificaciones guardadas')),
      );
    } catch (e) {
      print('Error guardando calificaciones: $e');
      _mostrarError('Error al guardar calificaciones: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificar ${widget.materia}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _estudiantesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay estudiantes'));
          } else {
            return _buildEstudiantesList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildEstudiantesList(List<Map<String, dynamic>> estudiantes) {
    List<TextEditingController> controllers = List.generate(
      estudiantes.length,
          (index) => TextEditingController(text: estudiantes[index]['calificacion']?.toString() ?? ''),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Grupo: ${widget.grupo}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: estudiantes.length,
            itemBuilder: (context, index) {
              final estudiante = estudiantes[index];
              return ListTile(
                title: Text(estudiante['nombre']),
                trailing: SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Calificación',
                    ),
                    onChanged: (value) {
                      estudiantes[index]['calificacion'] = double.tryParse(value);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () => _guardarCalificaciones(estudiantes, controllers),
          child: Text('Guardar Calificaciones'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}