import 'package:flutter/material.dart';
import '/models/location_model.dart';
import '/services/location_service.dart';

class LocationsListPage extends StatefulWidget {
  final int userId;

  const LocationsListPage({
    super.key,
    required this.userId,
  });

  @override
  State<LocationsListPage> createState() => _LocationsListPageState();
}

class _LocationsListPageState extends State<LocationsListPage> {
  Future<List<LocationModel>>? locationsFuture;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() {
    setState(() {
      locationsFuture = LocationService.getUserLocations(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una ubicación'),
      ),
      body: FutureBuilder<List<LocationModel>>(
        future: locationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No tienes ubicaciones guardadas"),
            );
          }

          final locations = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _loadLocations(),
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (_, i) {
                final loc = locations[i];

                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(loc.street ?? "Ubicación ${loc.id}"),
                  subtitle: Text(
                    "${loc.street} #${loc.number}, ${loc.country}",
                  ),
                  trailing: loc.isDefault
                      ? const Icon(Icons.star, color: Colors.orange)
                      : null,
                  onTap: () {
                    // 👇 SOLO DEVUELVE LA UBICACIÓN
                    Navigator.pop(context, loc);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
