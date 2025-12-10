import 'package:flutter/material.dart';
import 'locations_list_page.dart';
import 'add_location_page.dart';

class LocationTabsPage extends StatelessWidget {
  final int userId;

  const LocationTabsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis ubicaciones"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.location_on), text: "Mis ubicaciones"),
              Tab(icon: Icon(Icons.add_location), text: "Agregar"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LocationsListPage(userId: userId),
            AddLocationPage(userId: userId),
          ],
        ),
      ),
    );
  }
}
