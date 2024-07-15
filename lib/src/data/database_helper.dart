import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    // Remove this line in production. Only use for testing.
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertDummyData(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT, estudiante_id INTEGER, maestro_id INTEGER, admin_id INTEGER, role TEXT, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id), FOREIGN KEY(admin_id) REFERENCES admin(id))",
    );
    await db.execute(
      "CREATE TABLE estudiantes(id INTEGER PRIMARY KEY, nombre TEXT, edad INTEGER, carrera TEXT, grupo TEXT, matricula INTEGER UNIQUE)",
    );
    await db.execute(
      "CREATE TABLE maestro(id INTEGER PRIMARY KEY, nombre TEXT)",
    );
    await db.execute(
        "CREATE TABLE curso(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignaturas_id INTEGER, maestro_id INTEGER, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignaturas_id) REFERENCES asignaturas(id), FOREIGN KEY(maestro_id) REFERENCES maestro(id))"
    );
    await db.execute(
      "CREATE TABLE admin(id INTEGER PRIMARY KEY, nombre TEXT)",
    );
    await db.execute(
      "CREATE TABLE calificaciones(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignatura_id INTEGER, calificacion REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id))",
    );
    await db.execute(
      "CREATE TABLE asignaturas(id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT, cuatrimestre INTEGER )",
    );
    await db.execute(
      "CREATE TABLE becas(id INTEGER PRIMARY KEY, estudiante_id INTEGER, tipo TEXT, monto REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id))",
    );
  }

  Future<void> _insertDummyData(Database db) async {
    await db.insert('estudiantes', {'id': 1, 'nombre': 'Juan antonio', 'edad': 20, 'carrera': 'tecnologias de la comunicacion', 'grupo': 'TI 5', 'matricula': 23040003});
    await db.insert('estudiantes', {'id': 3, 'nombre': 'Juan Lopez', 'edad': 20, 'carrera': 'tecnologias de la comunicacion', 'grupo': 'TI 3', 'matricula': 32323});
    await db.insert('estudiantes', {'id': 2, 'nombre': 'Maria Lopez', 'edad': 22, 'carrera': 'tecnologias de la comunicacion', 'grupo': 'TI 2', 'matricula': 23040011});

    await db.insert('maestro', {'id': 1, 'nombre': 'Profesor juan'});
    await db.insert('maestro', {'id': 2, 'nombre': 'Profesor García'});
    await db.insert('admin', {'id': 1, 'nombre': 'Admin Principal'});

    await db.insert('curso', {'id': 1, 'estudiante_id': 1, 'asignaturas_id': 1, 'maestro_id': 1});
    await db.insert('curso', {'id': 2, 'estudiante_id': 2, 'asignaturas_id': 2, 'maestro_id': 1});
    await db.insert('curso', {'id': 3, 'estudiante_id': 3,'asignaturas_id':3,'maestro_id':2});
    await db.insert('curso', {'id': 4, 'estudiante_id': 1, 'asignaturas_id':4,'maestro_id':2});

    await db.insert('users', {'id': 1, 'username': 'estudiante', 'password': 'estudiante', 'estudiante_id': 1, 'maestro_id': null, 'admin_id': null, 'role': 'estudiante'});
    await db.insert('users', {'id': 4, 'username': 'estudiante2', 'password': 'estudiante2', 'estudiante_id': 2, 'maestro_id': null, 'admin_id': null, 'role': 'estudiante'});
    await db.insert('users', {'id': 2, 'username': 'maestro', 'password': 'maestro', 'estudiante_id': null, 'maestro_id': 1, 'admin_id': null, 'role': 'maestro'});
    await db.insert('users', {'id': 5, 'username': 'maestro2', 'password': 'maestro2', 'estudiante_id': null, 'maestro_id': 2, 'admin_id': null, 'role': 'maestro'});
    await db.insert('users', {'id': 3, 'username': 'admin', 'password': 'admin', 'estudiante_id': null, 'maestro_id': null, 'admin_id': 1, 'role': 'admin'});

    await db.insert('asignaturas', {'id': 1, 'nombre': 'Matemáticas', 'descripcion': 'Curso de Matemáticas básicas', 'cuatrimestre': 2});
    await db.insert('asignaturas', {'id': 2, 'nombre': 'Historia', 'descripcion': 'Curso de Historia universal', 'cuatrimestre': 2});
    await db.insert('asignaturas', {'id': 3, 'nombre': 'programacion', 'descripcion': 'Curso de Historia universal', 'cuatrimestre': 3});
    await db.insert('asignaturas', {'id': 4, 'nombre': 'filosofia','descripcion':'xd','cuatrimestre': 4});

    await db.insert('calificaciones', {'id': 1, 'estudiante_id': 1, 'asignatura_id': 1, 'calificacion': 85.5});
    await db.insert('calificaciones', {'id': 2, 'estudiante_id': 2, 'asignatura_id': 2, 'calificacion': 90.0});
    await db.insert('calificaciones', {'id': 6, 'estudiante_id': 2, 'asignatura_id': 1, 'calificacion': 81.0});
    await db.insert('calificaciones', {'id': 7, 'estudiante_id': 2, 'asignatura_id': 3, 'calificacion': 91.0});

    await db.insert('becas', {'id': 1, 'estudiante_id': 1, 'tipo': 'Beca de excelencia', 'monto': 1000.0});
    await db.insert('becas', {'id': 2, 'estudiante_id': 2, 'tipo': 'Beca deportiva', 'monto': 500.0});
  }

  Future<List<Map<String, dynamic>>> getEstudiantes() async {
    final db = await database;
    return await db.query('estudiantes');
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
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

  Future<List<Map<String, dynamic>>> cargarEstudiantes(String grupo) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT id, nombre, edad, carrera, matricula
    FROM estudiantes
    WHERE grupo = ?
    ORDER BY nombre;
  ''', [grupo]);
    return results;
  }

  Future<List<Map<String, dynamic>>> ListaGrupos(int maestroId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT DISTINCT e.grupo AS studentGroup, a.nombre AS nameMateria, c.asignaturas_id AS asignatura_id, c.estudiante_id AS estudiante_id
    FROM curso c
    INNER JOIN asignaturas a ON a.id = c.asignaturas_id
    INNER JOIN estudiantes e ON e.id = c.estudiante_id
    WHERE c.maestro_id = ?
    ORDER BY e.grupo;
  ''', [maestroId]);
    return results;
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCalificacion(Map<String, dynamic> calificacion) async {
    final db = await database;
    try {
      print('Iniciando inserción/actualización de calificación en la base de datos...');
      print('Datos de calificación: $calificacion');

      await db.transaction((txn) async {
        // Primero, intentamos actualizar una calificación existente
        int updatedRows = await txn.rawUpdate(
            'UPDATE calificaciones SET calificacion = ? WHERE estudiante_id = ? AND asignatura_id = ?',
            [calificacion['calificacion'], calificacion['estudiante_id'], calificacion['asignatura_id']]
        );
        print('Filas actualizadas: $updatedRows');

        // Si no se actualizó ninguna fila, insertamos una nueva
        if (updatedRows == 0) {
          int insertedId = await txn.rawInsert(
              'INSERT INTO calificaciones(estudiante_id, asignatura_id, calificacion) VALUES (?, ?, ?)',
              [calificacion['estudiante_id'], calificacion['asignatura_id'], calificacion['calificacion']]
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
        print('No se encontró calificación para estudiante_id: $estudianteId, asignatura_id: $asignaturaId');
      }
    } catch (e) {
      print('Error al verificar calificación: $e');
    }
  }

  Future<void> verificarTablaCalificaciones() async {
    final db = await database;
    try {
      List<Map> result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='calificaciones'");
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
}