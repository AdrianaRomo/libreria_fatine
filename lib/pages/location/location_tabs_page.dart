import 'package:flutter/material.dart';
import 'locations_list_page.dart';
import 'add_location_page.dart';
import '/models/book.dart';

class LocationTabsPage extends StatefulWidget {
  final int userId;
  final Book book;

  const LocationTabsPage({
    super.key,
    required this.userId,
    required this.book,
  });

  @override
  State<LocationTabsPage> createState() => _LocationTabsPageState();
}

class _LocationTabsPageState extends State<LocationTabsPage> {
  int refreshKey = 0;

  void refreshLocations() {
    setState(() {
      refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[700],
          foregroundColor: Colors.black,
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
            LocationsListPage(
              key: ValueKey(refreshKey),
              userId: widget.userId,
              book: widget.book,
            ),
            AddLocationPage(
              userId: widget.userId,
              onSaved: refreshLocations,
            ),
          ],
        ),

      ),
    );
  }
}
