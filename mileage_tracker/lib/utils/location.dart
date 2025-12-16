
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> ensureLocationPermission() async {
  final status = await Permission.locationWhenInUse.request();
  return status.isGranted;
}

Future<Position?> getCurrentPosition() async {
  final ok = await ensureLocationPermission();
  if (!ok) return null;
  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    timeLimit: const Duration(seconds: 8),
  );
}
