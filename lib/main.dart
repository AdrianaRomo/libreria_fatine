import 'package:flutter/material.dart';
import 'pages/book_detail.dart';
import 'models/book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


void main() {
  runApp(const LibreriaFatineApp());
}

class LibreriaFatineApp extends StatelessWidget {
  const LibreriaFatineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librería Fatine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = loadBooks();
  }

  Future<List<Book>> loadBooks() async {
    final jsonString = await rootBundle.loadString("assets/data/books.json");
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((e) => Book.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ["Ciencia ficción", "Drama", "Thriller", "Tecnología"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Librería Fatine"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: categories.map((cat) {
                final filtered =
                books.where((b) => b.category == cat).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(cat, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final book = filtered[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
                              );
                            },
                            child: Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 12),
                              child: Card(
                                child: Column(
                                  children: [
                                    Image.network(book.image, height: 150, fit: BoxFit.cover),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(book.title),
                                          Text(book.author, style: TextStyle(color: Colors.grey)),
                                          Text("\$${book.price}", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
