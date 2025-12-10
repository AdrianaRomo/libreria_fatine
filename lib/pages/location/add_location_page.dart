import 'package:flutter/material.dart';
import '/services/location_service.dart';

class AddLocationPage extends StatefulWidget {
  final int userId;

  const AddLocationPage({super.key, required this.userId});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  bool loading = false;

  // Reemplaza con tu lógica de GPS
  double lat = 19.4326;
  double lng = -99.1332;

  Future<void> saveLocation() async {
    setState(() => loading = true);

    bool success = await LocationService.saveLocation(widget.userId, lat, lng);

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Ubicación guardada" : "Error al guardar"),
      ),
    );

    if (success) {
      // refresca la lista si quieres
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading
          ? const CircularProgressIndicator()
          : ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text("Guardar ubicación actual"),
        onPressed: saveLocation,
      ),
    );
  }
}
