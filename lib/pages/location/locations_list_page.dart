import 'package:flutter/material.dart';
import '/models/location_model.dart';
import '/models/book.dart';
import '/services/location_service.dart';
import '/pages/payment/payment_methods_tabs_page.dart';


class LocationsListPage extends StatefulWidget {
  final int userId;
  final Book book;

  const LocationsListPage({
    super.key,
    required this.userId,
    required this.book,
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
    locationsFuture = LocationService.getUserLocations(widget.userId);
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
                  title: Text(loc.street),
                  onTap: () async {
                    final paymentSelected = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodsTabsPage(
                          userId: widget.userId,
                          locationId: loc.id,
                          book: widget.book,
                        ),
                      ),
                    );

                    if (paymentSelected == true) {
                      Navigator.pop(context, true);
                    }
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
