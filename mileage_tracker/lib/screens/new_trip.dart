
import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../storage/trips.dart';
import '../utils/location.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});
  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final originCtrl = TextEditingController(text: 'Home');
  final destCtrl = TextEditingController();
  final beginCtrl = TextEditingController();
  final endCtrl = TextEditingController();
  final purposeCtrl = TextEditingController();
  TripType type = TripType.Work;

  double? startLat, startLng, endLat, endLng;

  Future<void> onCaptureStart() async {
    final pos = await getCurrentPosition();
    if (pos != null) {
      setState(() { startLat = pos.latitude; startLng = pos.longitude; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Start location captured')));
    }
  }

  Future<void> onEndAndSave() async {
    final pos = await getCurrentPosition();
    if (pos != null) { endLat = pos.latitude; endLng = pos.longitude; }

    final odBegin = beginCtrl.text.isNotEmpty ? double.tryParse(beginCtrl.text) : null;
    final odEnd   = endCtrl.text.isNotEmpty ? double.tryParse(endCtrl.text) : null;

    if (odBegin != null && odEnd != null && odEnd < odBegin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Odometer end is less than begin')));
      return;
    }

    await insertTrip(Trip(
      dateISO: DateTime.now().toIso8601String().substring(0,10),
      origin: originCtrl.text,
      destination: destCtrl.text,
      odometerBegin: odBegin,
      odometerEnd: odEnd,
      type: type,
      purpose: purposeCtrl.text.isEmpty ? null : purposeCtrl.text,
      gpsStartLat: startLat, gpsStartLng: startLng,
      gpsEndLat: endLat,     gpsEndLng: endLng,
    ));

    if (mounted) Navigator.pop(context);
  }

  Widget quickChips({required String label, required void Function(String) onPick}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Wrap(spacing: 8, children: [
          ActionChip(label: const Text('Home'), onPressed: () => onPick('Home')),
          ActionChip(label: const Text('Office'), onPressed: () => onPick('Office')),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Trip')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            ElevatedButton(onPressed: onCaptureStart, child: const Text('Capture Start Location')),
            const SizedBox(height: 8),
            TextField(controller: originCtrl, decoration: const InputDecoration(labelText: 'Origin (free text)')),
            const SizedBox(height: 6),
            quickChips(label: 'Set origin:', onPick: (v){ setState(()=> originCtrl.text = v); }),
            const SizedBox(height: 12),
            TextField(controller: destCtrl,   decoration: const InputDecoration(labelText: 'Destination (free text)')),
            const SizedBox(height: 6),
            quickChips(label: 'Set destination:', onPick: (v){ setState(()=> destCtrl.text = v); }),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: beginCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Odometer Begin'))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: endCtrl,   keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Odometer End'))),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('Work'), selected: type == TripType.Work, onSelected: (_) => setState(() => type = TripType.Work)),
              ChoiceChip(label: const Text('Personal'), selected: type == TripType.Personal, onSelected: (_) => setState(() => type = TripType.Personal)),
            ]),
            TextField(controller: purposeCtrl, decoration: const InputDecoration(labelText: 'Purpose of Trip (optional)')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onEndAndSave, child: const Text('Capture End Location & Save')),
          ],
        ),
      ),
    );
  }
}
