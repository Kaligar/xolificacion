import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Constantes para nombres de tablas
  static const String TABLE_USERS = 'users';
  static const String TABLE_ESTUDIANTES = 'estudiantes';
  static const String TABLE_MAESTRO = 'maestro';
  static const String TABLE_CURSO = 'curso';
  static const String TABLE_ADMIN = 'admin';
  static const String TABLE_CALIFICACIONES = 'calificaciones';
  static const String TABLE_ASIGNATURAS = 'asignaturas';
  static const String TABLE_BECAS = 'becas';
  static const String TABLE_GRUPO = 'grupo';
  static const String TABLE_INTEGRANTES = 'integrantes';
  static const String TABLE_CURSOIMPARTIDO = 'cursoimpartido';

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    print("Inicializando base de datos en: $path");

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        print("Creando tablas de la base de datos...");
        await _createTables(db);
        if (kDebugMode) {
          print("Insertando datos de prueba...");
          await _insertDummyData(db);
        }
        print("Base de datos inicializada correctamente.");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print(
            "Actualizando base de datos de versión $oldVersion a $newVersion");
        if (oldVersion < 3) {
          await db.execute(
            "CREATE TABLE IF NOT EXISTS $TABLE_CURSOIMPARTIDO(id INTEGER PRIMARY KEY, grupo_id INTEGER, asignatura_id INTEGER, maestro_id INTEGER, FOREIGN KEY(grupo_id) REFERENCES $TABLE_GRUPO(id), FOREIGN KEY(asignatura_id) REFERENCES $TABLE_ASIGNATURAS(id), FOREIGN KEY(maestro_id) REFERENCES $TABLE_MAESTRO(id))",
          );
        }
      },
    );
  }


  Future<void> _createTables(Database db) async {
    print("Creando tabla users...");
    await db.execute(
      "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT, estudiante_id INTEGER, maestro_id INTEGER, admin_id INTEGER, role TEXT, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id), FOREIGN KEY(admin_id) REFERENCES admin(id))",
    );

    print("Creando tabla estudiantes...");
    await db.execute(
      "CREATE TABLE estudiantes(id INTEGER PRIMARY KEY, nombre TEXT, edad INTEGER, carrera TEXT, grupo TEXT, matricula INTEGER UNIQUE)",
    );

    print("Creando tabla maestro...");
    await db.execute(
      "CREATE TABLE maestro(id INTEGER PRIMARY KEY, nombre TEXT)",
    );

    print("Creando tabla curso...");
    await db.execute(
        "CREATE TABLE curso(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignaturas_id INTEGER, maestro_id INTEGER, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignaturas_id) REFERENCES asignaturas(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id))"
    );

    print("Creando tabla admin...");
    await db.execute(
      "CREATE TABLE admin(id INTEGER PRIMARY KEY, nombre TEXT)",
    );

    print("Creando tabla calificaciones...");
    await db.execute(
      "CREATE TABLE calificaciones(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignatura_id INTEGER, calificacion REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id))",
    );

    print("Creando tabla asignaturas...");
    await db.execute(
      "CREATE TABLE asignaturas(id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT, cuatrimestre INTEGER )",
    );

    print("Creando tabla becas...");
    await db.execute(
      "CREATE TABLE becas(id INTEGER PRIMARY KEY, estudiante_id INTEGER, tipo TEXT, monto REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id))",
    );
    print("Creando tabla grupo...");
    await db.execute(
      "CREATE TABLE grupo(id INTEGER PRIMARY KEY, nombre TEXT)",
    );
    print("Creando tabla integrantes...");
    await db.execute(
      "CREATE TABLE integrantes(id INTEGER PRIMARY KEY, grupo_id INTEGER, estudiante_id INTEGER, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(grupo_id) REFERENCES grupo(id))",
    );
    print("Creando tabla cursoimpartido...");
    await db.execute(
      "CREATE TABLE cursoimpartido(id INTEGER PRIMARY KEY, grupo_id INTEGER, asignatura_id INTEGER, maestro_id INTEGER, FOREIGN KEY(grupo_id) REFERENCES grupo(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id))",
    );

    print("Todas las tablas creadas exitosamente.");
  }

  Future<void> _insertDummyData(Database db) async {
    print("Insertando datos de prueba...");

    await db.insert('estudiantes', {
      'id': 1,
      'nombre': 'Juan antonio',
      'edad': 20,
      'carrera': 'tecnologias de la comunicacion',
      'grupo': 'TI 5',
      'matricula': 23040003
    });
    await db.insert('estudiantes', {
      'id': 3,
      'nombre': 'Juan Lopez',
      'edad': 20,
      'carrera': 'tecnologias de la comunicacion',
      'grupo': 'TI 3',
      'matricula': 32323
    });
    await db.insert('estudiantes', {
      'id': 2,
      'nombre': 'Maria Lopez',
      'edad': 22,
      'carrera': 'tecnologias de la comunicacion',
      'grupo': 'TI 2',
      'matricula': 23040011
    });

    await db.insert('maestro', {'id': 1, 'nombre': 'Profesor juan'});
    await db.insert('maestro', {'id': 2, 'nombre': 'Profesor García'});
    await db.insert('admin', {'id': 1, 'nombre': 'Admin Principal'});

    await db.insert('curso', {'id': 1, 'estudiante_id': 1, 'asignaturas_id': 1, 'maestro_id': 1});
    await db.insert('curso', {'id': 2, 'estudiante_id': 2, 'asignaturas_id': 2, 'maestro_id': 1});
    await db.insert('curso', {'id': 3, 'estudiante_id': 3, 'asignaturas_id': 3, 'maestro_id': 2});
    await db.insert('curso', {'id': 4, 'estudiante_id': 1, 'asignaturas_id': 4, 'maestro_id': 2});


    await db.insert('grupo', {'id': 1, 'nombre': 'TI2'});
    await db.insert('grupo', {'id': 2, 'nombre': 'ENR2'});

    await db.insert('integrantes', {'id': 1, 'grupo_id': 1, 'estudiante_id': 1});
    await db.insert('integrantes', {'id': 2, 'grupo_id': 1, 'estudiante_id': 2});
    await db.insert('integrantes', {'id': 3, 'grupo_id': 2, 'estudiante_id': 3});

    await db.insert('cursoimpartido', {'id': 1, 'grupo_id': 1, 'asignatura_id': 1, 'maestro_id': 1});
    await db.insert('cursoimpartido', {'id': 2, 'grupo_id': 1, 'asignatura_id': 2, 'maestro_id': 2});
    await db.insert('cursoimpartido', {'id': 3, 'grupo_id': 1, 'asignatura_id': 3, 'maestro_id': 1});
    await db.insert('cursoimpartido', {'id': 4, 'grupo_id': 1, 'asignatura_id': 4, 'maestro_id': 2});
    await db.insert('cursoimpartido', {'id': 5, 'grupo_id': 2, 'asignatura_id': 1, 'maestro_id': 2});
    await db.insert('cursoimpartido', {'id': 6, 'grupo_id': 2, 'asignatura_id': 2, 'maestro_id': 1});
    await db.insert('cursoimpartido', {'id': 7, 'grupo_id': 2, 'asignatura_id': 3, 'maestro_id': 2});
    await db.insert('cursoimpartido', {'id': 8, 'grupo_id': 2, 'asignatura_id': 4, 'maestro_id': 1});

    await db.insert('users', {'id': 1, 'username': 'estudiante', 'password': 'estudiante', 'estudiante_id': 1, 'maestro_id': null, 'admin_id': null, 'role': 'estudiante'});
    await db.insert('users', {'id': 4, 'username': 'estudiante2', 'password': 'estudiante2', 'estudiante_id': 2, 'maestro_id': null, 'admin_id': null, 'role': 'estudiante'});
    await db.insert('users', {'id': 2, 'username': 'maestro', 'password': 'maestro', 'estudiante_id': null, 'maestro_id': 1, 'admin_id': null, 'role': 'maestro'});
    await db.insert('users', {'id': 5, 'username': 'maestro2', 'password': 'maestro2', 'estudiante_id': null, 'maestro_id': 2, 'admin_id': null, 'role': 'maestro'});
    await db.insert('users', {'id': 3, 'username': 'admin', 'password': 'admin', 'estudiante_id': null, 'maestro_id': null, 'admin_id': 1, 'role': 'admin'});

    await db.insert('asignaturas', {'id': 1, 'nombre': 'Matemáticas', 'descripcion': 'Curso de Matemáticas básicas', 'cuatrimestre': 2});
    await db.insert('asignaturas', {'id': 2, 'nombre': 'Historia', 'descripcion': 'Curso de Historia universal', 'cuatrimestre': 2});
    await db.insert('asignaturas', {'id': 3, 'nombre': 'programacion', 'descripcion': 'Curso de Historia universal', 'cuatrimestre': 3});
    await db.insert('asignaturas', {'id': 4, 'nombre': 'filosofia', 'descripcion': 'xd', 'cuatrimestre': 4});


    await db.insert('becas', {'id': 1, 'estudiante_id': 1, 'tipo': 'Beca de excelencia', 'monto': 1000.0});
    await db.insert('becas', {'id': 2, 'estudiante_id': 2, 'tipo': 'Beca deportiva', 'monto': 500.0});

    print("Datos de prueba insertados exitosamente.");
  }

  Future<List<Map<String, dynamic>>> getEstudiantes() async {
    final db = await database;
    return await db.query(TABLE_ESTUDIANTES);
  }

  Future<void> insertMultipleEstudiantes(
      List<Map<String, dynamic>> estudiantes) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var estudiante in estudiantes) {
        await txn.insert(TABLE_ESTUDIANTES, estudiante);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getEstudiantesr() async {
    final db = await database;
    return await db.query('estudiantes');
  }

  Future<List<Map<String, dynamic>>> getMaestros() async {
    final db = await database;
    return await db.query('maestro');
  }

  Future<List<Map<String, dynamic>>> getGrupos() async {
    final db = await database;
    return await db.query('grupo');
  }

  Future<Map<String, dynamic>?> getUser(String username,
      String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getEstudianteById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'estudiantes',
      where: "id = ?",
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getCalificacionesById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT c.id, a.nombre, c.calificacion, a.cuatrimestre
      FROM calificaciones c
      INNER JOIN asignaturas a ON a.id = c.asignatura_id
      WHERE c.estudiante_id = ?
      ORDER BY a.cuatrimestre, a.nombre
    ''', [id]);
    return results;
  }

  Future<List<Map<String, dynamic>>> cargarEstudiantes(int grupo_id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT e.id AS id, e.nombre AS nombre, e.edad AS edad, e.carrera AS carrera, e.matricula AS matricula
      FROM integrantes i 
      INNER JOIN estudiantes e ON e.id = i.estudiante_id
      WHERE i.grupo_id = ?
      ORDER BY nombre;
    ''', [grupo_id]);
    return results;
  }

  Future<List<Map<String, dynamic>>> ListaGrupos(int maestroId) async {
    await verificarTablaCursoimpartido();
    final db = await database;
    try {
      print("Ejecutando consulta ListaGrupos para maestroId: $maestroId");
      List<Map<String, dynamic>> results = await db.rawQuery('''
          SELECT DISTINCT g.nombre AS studentGroup, a.nombre AS nameMateria, g.id AS grupo_id, c.asignatura_id AS asignatura_id
          FROM cursoimpartido c
          INNER JOIN grupo g ON g.id = c.grupo_id
          INNER JOIN asignaturas a ON a.id = c.asignatura_id
          WHERE c.maestro_id = ?
          ORDER BY g.nombre;
        ''', [maestroId]);
      print("Consulta ListaGrupos ejecutada exitosamente. Resultados: ${results
          .length}");
      return results;
    } catch (e) {
      print("Error en ListaGrupos: $e");
      rethrow;
    }
  }

  Future<void> verificarTablaCursoimpartido() async {
    final db = await database;
    try {
      List<Map> result = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='cursoimpartido'");
      if (result.isEmpty) {
        print('La tabla cursoimpartido no existe');
        await db.execute(
          "CREATE TABLE cursoimpartido(id INTEGER PRIMARY KEY, grupo_id INTEGER, asignatura_id INTEGER, maestro_id INTEGER, FOREIGN KEY(grupo_id) REFERENCES grupo(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id))",
        );
        print('Tabla cursoimpartido creada');
      } else {
        print('La tabla cursoimpartido ya existe');
      }
    } catch (e) {
      print('Error verificando tabla cursoimpartido: $e');
    }
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
        'users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCalificacion(Map<String, dynamic> calificacion) async {
    final db = await database;
    try {
      print(
          'Iniciando inserción/actualización de calificación en la base de datos...');
      print('Datos de calificación: $calificacion');

      await db.transaction((txn) async {
        // Primero, intentamos actualizar una calificación existente
        int updatedRows = await txn.rawUpdate(
            'UPDATE calificaciones SET calificacion = ? WHERE estudiante_id = ? AND asignatura_id = ?',
            [
              calificacion['calificacion'],
              calificacion['estudiante_id'],
              calificacion['asignatura_id']
            ]
        );
        print('Filas actualizadas: $updatedRows');

        // Si no se actualizó ninguna fila, insertamos una nueva
        if (updatedRows == 0) {
          int insertedId = await txn.rawInsert(
              'INSERT INTO calificaciones(estudiante_id, asignatura_id, calificacion) VALUES (?, ?, ?)',
              [
                calificacion['estudiante_id'],
                calificacion['asignatura_id'],
                calificacion['calificacion']
              ]
          );
          print('Nueva calificación insertada con ID: $insertedId');
        }
      });
      print('Calificación insertada/actualizada con éxito');
    } catch (e) {
      print('Error al insertar/actualizar calificación: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getMaestroById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'maestro',
      where: "id = ?",
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getAdminById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'admin',
      where: "id = ?",
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> verificarCalificacion(int estudianteId, int asignaturaId) async {
    final db = await database;
    try {
      List<Map> result = await db.rawQuery(
          'SELECT * FROM calificaciones WHERE estudiante_id = ? AND asignatura_id = ?',
          [estudianteId, asignaturaId]
      );
      if (result.isNotEmpty) {
        print('Calificación encontrada: ${result.first}');
      } else {
        print(
            'No se encontró calificación para estudiante_id: $estudianteId, asignatura_id: $asignaturaId');
      }
    } catch (e) {
      print('Error al verificar calificación: $e');
    }
  }

  Future<void> verificarTablaCalificaciones() async {
    final db = await database;
    try {
      List<Map> result = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='calificaciones'");
      if (result.isEmpty) {
        print('La tabla calificaciones no existe');
        await db.execute(
            "CREATE TABLE calificaciones(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignatura_id INTEGER, calificacion REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id))"
        );
        print('Tabla calificaciones creada');
      } else {
        print('La tabla calificaciones ya existe');
      }
    } catch (e) {
      print('Error verificando tabla calificaciones: $e');
    }
  }


  Future<int> updateEstudiante(int id, String nombre, int edad, String carrera,
      String grupo, int matricula) async {
    final db = await database;
    try {
      return await db.update(
        'estudiantes',
        {
          'nombre': nombre,
          'edad': edad,
          'carrera': carrera,
          'grupo': grupo,
          'matricula': matricula,
        },
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al actualizar estudiante: $e');
      return 0; // Retorna 0 si hay un error, indicando que no se actualizó ningún registro
    }
  }

  Future<int> insertEstudiante(Map<String, dynamic> estudiante) async {
    final db = await database;
    try {
      return await db.insert(
        TABLE_ESTUDIANTES,
        estudiante,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar estudiante: $e');
      return -1; // Retorna -1 en caso de error
    }
  }

  Future<int> insertGrupo(Map<String, dynamic> grupo) async {
    final db = await database;
    try {
      return await db.insert(
        TABLE_GRUPO,
        grupo,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar grupo: $e');
      return -1; // Retorna -1 en caso de error
    }
  }
  Future<int> updateGrupo(int id, String nuevoNombre) async {
    final db = await database;
    try {
      return await db.update(
        TABLE_GRUPO,
        {'nombre': nuevoNombre},
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al actualizar grupo: $e');
      return 0; // Retorna 0 si hay un error, indicando que no se actualizó ningún registro
    }
  }
  Future<int> insertMaestro(Map<String, dynamic> maestro) async {
    final db = await database;
    try {
      return await db.insert(
        TABLE_MAESTRO,
        maestro,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al insertar maestro: $e');
      return -1; // Retorna -1 en caso de error
    }
  }

  Future<int> updateMaestro(int id, String nombre) async {
    final db = await database;
    try {
      return await db.update(
        TABLE_MAESTRO,
        {'nombre': nombre},
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error al actualizar maestro: $e');
      return 0; // Retorna 0 si hay un error, indicando que no se actualizó ningún registro
    }
  }
}