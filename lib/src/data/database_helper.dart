import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    // Eliminar la base de datos existente (solo para pruebas)
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
          "CREATE TABLE admin(id INTEGER PRIMARY KEY, nombre TEXT)",
        );
        await db.execute(
          "CREATE TABLE calificaciones(id INTEGER PRIMARY KEY, estudiante_id INTEGER, asignatura_id INTEGER, calificacion REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id), FOREIGN KEY(asignatura_id) REFERENCES asignaturas(id))",
        );
        await db.execute(
          "CREATE TABLE asignaturas(id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT)",
        );
        await db.execute(
          "CREATE TABLE becas(id INTEGER PRIMARY KEY, estudiante_id INTEGER, tipo TEXT, monto REAL, FOREIGN KEY(estudiante_id) REFERENCES estudiantes(id))",
        );

        // Insertar datos dummy
        await db.insert('estudiantes', {'id': 1, 'nombre': 'Juan Lopez', 'edad': 20, 'carrera': 'tecnologias de la comunicacion', 'grupo': 'TI 2', 'matricula': 23040003});
        await db.insert('estudiantes', {'id': 2, 'nombre': 'Maria Lopez', 'edad': 22, 'carrera': 'tecnologias de la comunicacion', 'grupo': 'TI 2', 'matricula': 23040011});

        await db.insert('maestro', {'id': 1, 'nombre': 'Profesor García'});
        await db.insert('admin', {'id': 1, 'nombre': 'Admin Principal'});

        await db.insert('users', {'id': 1, 'username': 'estudiante', 'password': 'estudiante', 'estudiante_id': 1, 'maestro_id': null, 'admin_id': null, 'role': 'estudiante'});
        await db.insert('users', {'id': 2, 'username': 'maestro', 'password': 'maestro', 'estudiante_id': null, 'maestro_id': 1, 'admin_id': null, 'role': 'maestro'});
        await db.insert('users', {'id': 3, 'username': 'admin', 'password': 'admin', 'estudiante_id': null, 'maestro_id': null, 'admin_id': 1, 'role': 'admin'});

        await db.insert('asignaturas', {'id': 1, 'nombre': 'Matemáticas', 'descripcion': 'Curso de Matemáticas básicas'});
        await db.insert('asignaturas', {'id': 2, 'nombre': 'Historia', 'descripcion': 'Curso de Historia universal'});

        await db.insert('calificaciones', {'id': 1, 'estudiante_id': 1, 'asignatura_id': 1, 'calificacion': 85.5});
        await db.insert('calificaciones', {'id': 2, 'estudiante_id': 2, 'asignatura_id': 2, 'calificacion': 90.0});

        await db.insert('becas', {'id': 1, 'estudiante_id': 1, 'tipo': 'Beca de excelencia', 'monto': 1000.0});
        await db.insert('becas', {'id': 2, 'estudiante_id': 2, 'tipo': 'Beca deportiva', 'monto': 500.0});
      },
    );
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

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
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
}