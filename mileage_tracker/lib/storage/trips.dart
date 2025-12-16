
import 'package:sqflite/sqflite.dart';
import '../models/trip.dart';
import 'db.dart';

Future<int> insertTrip(Trip t) async {
  final db = await DB.instance;
  final totalKm = (t.odometerBegin != null && t.odometerEnd != null)
      ? (t.odometerEnd! - t.odometerBegin!).clamp(0, double.infinity)
      : t.totalKm ?? 0;

  final businessKm = t.type == TripType.Work ? totalKm : 0.0;
  final personalKm = t.type == TripType.Personal ? totalKm : 0.0;

  return db.insert('trips', {
    ...t.toMap(),
    'totalKm': totalKm,
    'businessKm': businessKm,
    'personalKm': personalKm,
  });
}

Future<List<Trip>> listTrips({DateTime? start, DateTime? end}) async {
  final db = await DB.instance;
  String where = '';
  List<Object?> args = [];
  if (start != null && end != null) {
    where = 'WHERE dateISO BETWEEN ? AND ?';
    args = [start.toIso8601String().substring(0,10), end.toIso8601String().substring(0,10)];
  }
  final rows = await db.rawQuery('SELECT * FROM trips ' + where + ' ORDER BY dateISO DESC, id DESC', args);
  return rows.map((m) => Trip.fromMap(m)).toList();
}

Future<Map<String,double>> monthTotals(DateTime month) async {
  final first = DateTime(month.year, month.month, 1);
  final last = DateTime(month.year, month.month + 1, 0);
  final db = await DB.instance;
  final res = await db.rawQuery(
    'SELECT SUM(businessKm) as b, SUM(personalKm) as p FROM trips WHERE dateISO BETWEEN ? AND ?',
    [first.toIso8601String().substring(0,10), last.toIso8601String().substring(0,10)],
  );
  final row = res.first;
  return {
    'business': (row['b'] as num?)?.toDouble() ?? 0,
    'personal': (row['p'] as num?)?.toDouble() ?? 0,
  };
}
