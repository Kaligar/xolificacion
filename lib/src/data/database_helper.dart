import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';

//gestion de la DataBase con sqflite
class DatabaseHelper {
  static final DatabaseHelper _instace = DatabaseHelper._internal();
  static Database? _database;

  //creacion de DatabaseHelper
  factory DatabaseHelper(){
    return _instace;
  }
// _internal es la única instancia dentro de DatabaseHelper
  //El patrón Singleton, solo una instancia en la clase
  DatabaseHelper._internal();

  //llama una instancia de la DataBase
  //si esta inicializado, llama al metodo _initDatabase()
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //_initDatabase(), metodo para crear y configurar la DataBase
  //calculamos la ruta del directorio y el nombre
  //onCreate,id,username,password
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)'
        );
      },
    );
  }

  // metodo,insertar un nuevo usuario en la tabla users
  //ConflictAlgorithm.replace, si ya existe un registro remplasa ID
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //buscar usuario
  //obtenemos instancia, realiza una consulta
  //query() buscamos parametros que cumplan con las condiciones
  Future<Map<String, dynamic>?> getUsers(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    //devuelve el primer resultado
    return results.isNotEmpty ? results.first : null;
  }
}