
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;
  static Future<Database> get instance async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'mileage.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE trips(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dateISO TEXT,
            origin TEXT,
            destination TEXT,
            odometerBegin REAL,
            odometerEnd REAL,
            totalKm REAL,
            businessKm REAL,
            personalKm REAL,
            purpose TEXT,
            type TEXT,
            gpsStartLat REAL,
            gpsStartLng REAL,
            gpsEndLat REAL,
            gpsEndLng REAL
          );
        """);
      },
    );
    return _db!;
  }
}
