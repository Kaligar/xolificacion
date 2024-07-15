import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class CalificarScreen extends StatefulWidget {
  final String grupo;
  final String materia;
  final int asignatura_id;

  const CalificarScreen({
    Key? key,
    required this.grupo,
    required this.materia,
    required this.asignatura_id
  }) : super(key: key);

  @override
  _CalificarScreenState createState() => _CalificarScreenState();
}

class _CalificarScreenState extends State<CalificarScreen> {
  List<Map<String, dynamic>> _estudiantes = [];
  List<TextEditingController> _controllers = [];
  bool isLoading = true;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.verificarTablaCalificaciones();
    _cargarEstudiantes();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarEstudiantes() async {
    try {
      final estudiantes = await dbHelper.cargarEstudiantes(widget.grupo);
      setState(() {
        _estudiantes = estudiantes;
        _controllers = List.generate(
          estudiantes.length,
              (index) => TextEditingController(text: estudiantes[index]['calificacion']?.toString() ?? ''),
        );
        isLoading = false;
      });
      print('Estudiantes cargados: $_estudiantes');
    } catch (e) {
      print('Error cargando estudiantes: $e');
      _mostrarError('Error al cargar estudiantes');
    }
  }

  Future<void> _guardarCalificaciones() async {
    try {
      print('Iniciando guardado de calificaciones...');
      for (int i = 0; i < _estudiantes.length; i++) {
        var estudiante = _estudiantes[i];
        var calificacion = double.tryParse(_controllers[i].text);
        if (calificacion != null) {
          print('Intentando guardar calificación para estudiante ID: ${estudiante['id']}, Asignatura ID: ${widget.asignatura_id}, Calificación: $calificacion');
          await dbHelper.insertCalificacion({
            'estudiante_id': estudiante['id'],
            'asignatura_id': widget.asignatura_id,
            'calificacion': calificacion,
          });
          await dbHelper.verificarCalificacion(estudiante['id'], widget.asignatura_id);
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Grupo: ${widget.grupo}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _estudiantes.length,
              itemBuilder: (context, index) {
                final estudiante = _estudiantes[index];
                return ListTile(
                  title: Text(estudiante['nombre']),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Calificación',
                      ),
                      onChanged: (value) {
                        _estudiantes[index]['calificacion'] = double.tryParse(value);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _guardarCalificaciones,
            child: Text('Guardar Calificaciones'),
          ),
        ],
      ),
    );
  }
}