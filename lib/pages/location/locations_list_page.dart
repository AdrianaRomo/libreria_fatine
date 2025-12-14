import 'package:flutter/material.dart';
import '/models/location_model.dart';
import '/services/location_service.dart';

class LocationsListPage extends StatefulWidget {
  final int userId;

  const LocationsListPage({super.key, required this.userId});

  @override
  State<LocationsListPage> createState() => _LocationsListPageState();
}

class _LocationsListPageState extends State<LocationsListPage> {
  late Future<List<LocationModel>> locations;

  @override
  void initState() {
    super.initState();
    locations = LocationService.getUserLocations(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LocationModel>>(
      future: locations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No tienes ubicaciones guardadas"),
          );
        }

        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            final loc = data[i];

            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(loc.name ?? "Ubicación ${loc.id}"),
              subtitle: Text("Lat: ${loc.lat}, Lng: ${loc.lng}"),
              trailing: loc.isDefault
                  ? const Icon(Icons.star, color: Colors.orange)
                  : null,
            );
          },
        );
      },
    );
  }
}
