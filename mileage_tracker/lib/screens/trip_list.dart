
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../storage/trips.dart';
import '../utils/csv_export.dart';
import '../models/trip.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});
  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  DateTime month = DateTime.now();
  List<Trip> trips = [];
  double business = 0, personal = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final first = DateTime(month.year, month.month, 1);
    final last  = DateTime(month.year, month.month + 1, 0);
    final data = await listTrips(start: first, end: last);
    final totals = await monthTotals(month);
    setState(() {
      trips = data;
      business = totals['business']!;
      personal = totals['personal']!;
    });
  }

  Future<void> _export() async {
    final path = await exportMonthToCsv(month);
    await Share.shareXFiles([XFile(path)], text: 'Mileage ${month.year}-${month.month.toString().padLeft(2,'0')}');
  }

  void _prevMonth() { setState(() { month = DateTime(month.year, month.month - 1, 1); }); _load(); }
  void _nextMonth() { setState(() { month = DateTime(month.year, month.month + 1, 1); }); _load(); }

  @override
  Widget build(BuildContext context) {
    final title = '${month.year}-${month.month.toString().padLeft(2,'0')}';
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips ($title)'),
        actions: [
          IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right)),
          IconButton(onPressed: _export, icon: const Icon(Icons.ios_share)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Chip(label: Text('Business: ${business.toStringAsFixed(0)} km')),
                Chip(label: Text('Personal: ${personal.toStringAsFixed(0)} km')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (_, i) {
                final t = trips[i];
                final total = t.totalKm ?? (t.odometerEnd!=null && t.odometerBegin!=null ? (t.odometerEnd! - t.odometerBegin!) : 0);
                return ListTile(
                  title: Text('${t.dateISO}  ${t.origin} → ${t.destination}'),
                  subtitle: Text('${t.type.name} • ${total.toStringAsFixed(0)} km • ${t.purpose ?? ''}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/new');
          if (mounted) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
