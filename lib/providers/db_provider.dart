import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {

  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database!;

    _database = await initDB();

    return _database!;

  }

  Future<Database> initDB() async {

    //Path de donde almacenaremos la bd
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join( documentsDirectory.path, 'ScansDB.db' );

  print(path);

    //Crear base de datos
  return await openDatabase(
    path,
    version: 1,
    onOpen: (db) { },
    onCreate: (Database db, int version) async{

    await db.execute('''
      CREATE TABLE Scans (
        id INTEGER PRIMARY KEY,
        tipo TEXT,
        valor TEXT
      )

    ''');

    }
  );
    
  }


  Future<int> nuevoScanRaw( ScanModel nuevoScan ) async{

    final id    = nuevoScan.id;
    final tipo  = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //Verificar que la bd se haya creado
    final db = await database;

    final res = await db.rawInsert('''

      INSERT INTO Scans( id, tipo, valor )
        VALUES( $id, '$tipo', '$valor' )

    ''');


    return res;


  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {

    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }

  Future<ScanModel?> getScanById( int id) async {

    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {

      return ScanModel.fromJson( res.first );

    } else {

      return null;

    }

  }

  Future<List<ScanModel?>> getTodosLosScans( ) async {

    final db = await database;
    final res = await db.query('Scans');

    if (res.isNotEmpty) {

      return res.map((e) => ScanModel.fromJson(e)).toList();

    } else {

      return [];

    }

  }


  Future<List<ScanModel?>> getScansPorTipo( String tipo ) async {

    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo= '$tipo'
    ''');

    if (res.isNotEmpty) {

      return res.map((e) => ScanModel.fromJson(e)).toList();

    } else {

      return [];

    }

  }

  Future<int> updateScan( ScanModel updateScan ) async{

    final db = await database;
    final res = await db.update('Scans', updateScan.toJson(), where: 'id = ?', whereArgs: [updateScan.id] );

    return res;

  }

  Future<int> deleteScan( int id ) async {

    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;

  }
  
  Future<int> deleteAllScan() async {

    final db = await database;
    final res = await db.rawDelete('''

    DELETE FROM Scans

    ''');

    return res;

  }

}

