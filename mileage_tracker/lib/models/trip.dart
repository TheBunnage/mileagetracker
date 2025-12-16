
enum TripType { Work, Personal }

class Trip {
  int? id;
  String dateISO; // YYYY-MM-DD
  String origin;
  String destination;
  double? odometerBegin;
  double? odometerEnd;
  double? totalKm;
  double? businessKm;
  double? personalKm;
  String? purpose;
  TripType type;
  double? gpsStartLat;
  double? gpsStartLng;
  double? gpsEndLat;
  double? gpsEndLng;

  Trip({
    this.id,
    required this.dateISO,
    required this.origin,
    required this.destination,
    this.odometerBegin,
    this.odometerEnd,
    this.totalKm,
    this.businessKm,
    this.personalKm,
    this.purpose,
    required this.type,
    this.gpsStartLat,
    this.gpsStartLng,
    this.gpsEndLat,
    this.gpsEndLng,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'dateISO': dateISO,
    'origin': origin,
    'destination': destination,
    'odometerBegin': odometerBegin,
    'odometerEnd': odometerEnd,
    'totalKm': totalKm,
    'businessKm': businessKm,
    'personalKm': personalKm,
    'purpose': purpose,
    'type': type.name,
    'gpsStartLat': gpsStartLat,
    'gpsStartLng': gpsStartLng,
    'gpsEndLat': gpsEndLat,
    'gpsEndLng': gpsEndLng,
  };

  static Trip fromMap(Map<String, Object?> m) => Trip(
    id: m['id'] as int?,
    dateISO: m['dateISO'] as String,
    origin: m['origin'] as String,
    destination: m['destination'] as String,
    odometerBegin: (m['odometerBegin'] as num?)?.toDouble(),
    odometerEnd: (m['odometerEnd'] as num?)?.toDouble(),
    totalKm: (m['totalKm'] as num?)?.toDouble(),
    businessKm: (m['businessKm'] as num?)?.toDouble(),
    personalKm: (m['personalKm'] as num?)?.toDouble(),
    purpose: m['purpose'] as String?,
    type: (m['type'] as String) == 'Work' ? TripType.Work : TripType.Personal,
    gpsStartLat: (m['gpsStartLat'] as num?)?.toDouble(),
    gpsStartLng: (m['gpsStartLng'] as num?)?.toDouble(),
    gpsEndLat: (m['gpsEndLat'] as num?)?.toDouble(),
    gpsEndLng: (m['gpsEndLng'] as num?)?.toDouble(),
  );
}
