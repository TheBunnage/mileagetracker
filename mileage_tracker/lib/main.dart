
import 'package:flutter/material.dart';
import 'screens/trip_list.dart';
import 'screens/new_trip.dart';

void main() => runApp(const MileageApp());

class MileageApp extends StatelessWidget {
  const MileageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mileage Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7DFF)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const TripListScreen(),
        '/new': (_) => const NewTripScreen(),
      },
    );
  }
}
