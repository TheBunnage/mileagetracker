
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/trip.dart';
import '../storage/trips.dart';

Future<String> exportMonthToCsv(DateTime month) async {
  final first = DateTime(month.year, month.month, 1);
  final last = DateTime(month.year, month.month + 1, 0);
  final trips = await listTrips(start: first, end: last);

  double totalKmCalculated(Trip t) {
    if (t.totalKm != null) return t.totalKm!;
    if (t.odometerBegin != null && t.odometerEnd != null) return (t.odometerEnd! - t.odometerBegin!);
    return 0;
  }

  final rows = <List<dynamic>>[
    [
      'Date','Point of Origin','Destination','Odometer Begin','Odometer End','Total KM's','Business KM's','Personal KM's','Purpose of Trip','GPS Start (lat,lng)','GPS End (lat,lng)'
    ]
  ];

  double sumTotal = 0, sumBusiness = 0, sumPersonal = 0;

  for (final t in trips) {
    final total = totalKmCalculated(t);
    sumTotal += total;
    sumBusiness += (t.type.name == 'Work') ? total : 0;
    sumPersonal += (t.type.name == 'Personal') ? total : 0;
    rows.add([
      t.dateISO,
      t.origin,
      t.destination,
      t.odometerBegin ?? '',
      t.odometerEnd ?? '',
      total,
      (t.type.name == 'Work') ? total : 0,
      (t.type.name == 'Personal') ? total : 0,
      t.purpose ?? '',
      (t.gpsStartLat!=null && t.gpsStartLng!=null) ? '${t.gpsStartLat},${t.gpsStartLng}' : '',
      (t.gpsEndLat!=null && t.gpsEndLng!=null) ? '${t.gpsEndLat},${t.gpsEndLng}' : '',
    ]);
  }

  rows.add(['Total','','','','',sumTotal,sumBusiness,sumPersonal,'','']);

  final csv = const ListToCsvConverter().convert(rows);
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/mileage_${month.year}_${month.month.toString().padLeft(2,'0')}.csv');
  await file.writeAsString(csv);
  return file.path;
}
