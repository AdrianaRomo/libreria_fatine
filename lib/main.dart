import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '/core/config/api_config.dart';

import 'models/cart.dart';
import 'models/book.dart';

import 'pages/book_detail.dart';
import 'pages/qr_scanner_page.dart';
import 'pages/cart_page.dart';
import 'pages/login_page.dart';
import 'pages/book_search_delegate.dart';

import 'services/auth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const LibreriaFatineApp(),
    ),
  );
}
class LibreriaFatineApp extends StatelessWidget {
  const LibreriaFatineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librería Abejita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/cart': (_) => const CartPage(),
      },
    );
  }
}


List<Book> allBooks = [];
List<Book> filteredBooks = [];


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> allBooks = [];
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = loadBooks();
  }


  Future<List<Book>> loadBooks() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final books = data.map((e) => Book.fromJson(e)).toList();

      allBooks = books;

      return books;
    } else {
      throw Exception("Error al cargar los libros");
    }
  }



  @override
  Widget build(BuildContext context) {
    final categories = ["Drama y Romance", "Autobiografía", "Epopeya", "Ficción Historica", "Ficcion Gotica", "Ficción Gotica", "Historia", "Horror", "Juvenil", "Novela Histórica", "Novela Mágica", "Romance","Fantasía"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        title: const Text(
          "Librería Abejita",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
      IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        if (allBooks.isEmpty) return;

        final result = await showSearch<Book?>(
          context: context,
          delegate: BookSearchDelegate(allBooks),
        );

        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailPage(book: result),
            ),
          );
        }
      },
    ),


          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QRScannerPage()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _openAccountMenu(context);
            },
          ),
          // Carrito con contador
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(context, '/cart');

                      if (result == true) {
                        setState(() {
                          booksFuture = loadBooks();
                        });
                      }
                    },
                  ),
                  // Contador del carrito
                  if (cart.items.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cart.items.length.toString(),
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los libros'));
          }

          final books = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final filteredBooks =
              books.where((b) => b.category == category).toList();

              if (filteredBooks.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      category,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredBooks.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, i) {
                        final book = filteredBooks[i];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailPage(book: book),
                              ),
                            );

                            if (result == true) {
                              setState(() {
                                booksFuture = loadBooks();
                              });
                            }
                          },
                          child: Container(
                            width: 180,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: book.image,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => SizedBox(
                                        height: 150,
                                        child: Center(
                                          child:
                                          CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) =>
                                      const Icon(Icons.error, size: 50),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.author,
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "\$${book.price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
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
                  const SizedBox(height: 24),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

void _openAccountMenu(BuildContext context) async {
  final userId = await AuthService.getUserId();
  final userName = await AuthService.getUserName();

  if (userId == null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(fromCart: true),
      ),
    );
    return; //
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, size: 40),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? 'Usuario #$userId',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Sesión activa',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 30),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await AuthService.logout();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage(fromCart: true)),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.switch_account),
              title: const Text('Cambiar cuenta'),
              onTap: () async {
                await AuthService.logout();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage(fromCart: true)),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
