import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '/models/cart.dart';
import '/models/book.dart';

import '/pages/login_page.dart';
import '/pages/location/location_tabs_page.dart';

import '/services/auth_service.dart';
import '/services/book_service.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title,style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Hero(
              tag: book.title,
              child: CachedNetworkImage(
                imageUrl: book.image,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => SizedBox(
                  height: 350,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (_, __, ___) => Icon(Icons.error, size: 50),
              ),
            ),

            // ---------- CONTENIDO ----------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Título
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Autor
                  Text(
                    "de ${book.author}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Precio
                  Text(
                    "\$${double.tryParse(book.price.toString())?.toStringAsFixed(2) ?? book.price}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // AStock
                  Text(
                    "Unidades Disponibles: ${book.qty}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Descripción del producto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    book.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),

                  const SizedBox(height: 30),

                  // ---------- BOTÓN COMPRAR ----------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final userId = await AuthService.getUserId();

                        if (userId == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(fromCart: true),
                            ),
                          );
                          return;
                        }

                        final purchased = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LocationTabsPage(
                              userId: userId,
                              book: book,
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (purchased == true && context.mounted) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Compra completada'),
                              content: Text(
                                'Libro: ${book.title}\n'
                                    'Total: \$${book.price}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Comprar ahora",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------- BOTÓN CARRITO ----------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        final cart = Provider.of<CartModel>(context, listen: false);
                        cart.add(book);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${book.title} agregado al carrito'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        "Agregar al carrito",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  RelatedBooksSection(book: book),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedBooksSection extends StatelessWidget {
  final Book book;

  const RelatedBooksSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: BookService.getRelatedBooks(book),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final books = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Más libros similares',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: books.length,
                  itemBuilder: (_, i) {
                    final b = books[i];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailPage(book: b),
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: b.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
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
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
