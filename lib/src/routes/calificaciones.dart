  import 'package:flutter/material.dart';
  import '../data/database_helper.dart';

  class CalificacionScreen extends StatefulWidget {
    final int estudianteId;

    CalificacionScreen({required this.estudianteId});

    @override
    _CalificacionScreenState createState() => _CalificacionScreenState();
  }

  class _CalificacionScreenState extends State<CalificacionScreen> {
    List<Map<String, dynamic>>? _calificaciones;
    bool _isLoading = true;

    @override
    void initState() {
      super.initState();
      _loadCalificaciones();
    }


    Map<int, List<Map<String, dynamic>>> _agruparPorCuatrimestre(List<Map<String, dynamic>> calificaciones) {
      Map<int, List<Map<String, dynamic>>> calificacionesPorCuatrimestre = {};
      for (var calificacion in calificaciones) {
        int cuatrimestre = calificacion['cuatrimestre'];
        if (!calificacionesPorCuatrimestre.containsKey(cuatrimestre)) {
          calificacionesPorCuatrimestre[cuatrimestre] = [];
        }
        calificacionesPorCuatrimestre[cuatrimestre]!.add(calificacion);
      }
      return calificacionesPorCuatrimestre;
    }

    Future<void> _loadCalificaciones() async {
      DatabaseHelper dbHelper = DatabaseHelper();
      final calificaciones = await dbHelper.getCalificacionesById(widget.estudianteId);
      setState(() {
        _calificaciones = calificaciones;
        _isLoading = false;
      });
      print('Calificaciones cargadas: $_calificaciones');
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
                Text('UTC',
                    style: TextStyle(
                      fontFamily: 'Hanuman',
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFFFFF),
                    )),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _calificaciones == null || _calificaciones!.isEmpty
            ? Center(child: Text('No se encontraron calificaciones'))
            : Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Salir',
                    style: TextStyle(
                      fontFamily: 'Hanuman',
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF000000),
                    )),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(30, 50),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _agruparPorCuatrimestre(_calificaciones!).length,
                  itemBuilder: (context, index) {
                    int cuatrimestre = _agruparPorCuatrimestre(_calificaciones!).keys.elementAt(index);
                    List<Map<String, dynamic>> calificacionesCuatrimestre = _agruparPorCuatrimestre(_calificaciones!)[cuatrimestre]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cuatrimestre $cuatrimestre', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        ...calificacionesCuatrimestre.map((calificacion) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Materia: ${calificacion['nombre']}', style: TextStyle(fontSize: 18)),
                            Text('Calificación: ${calificacion['calificacion']}', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                          ],
                        )).toList(),
                        SizedBox(height: 20),
                      ],

                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }}