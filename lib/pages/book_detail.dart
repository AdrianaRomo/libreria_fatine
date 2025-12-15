import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:libreria_fatine/pages/location/location_tabs_page.dart';
import 'package:libreria_fatine/services/auth_service.dart';
import 'package:libreria_fatine/models/cart.dart';
import 'package:libreria_fatine/models/BUnity.dart';
import 'package:libreria_fatine/pages/login_page.dart';
import '../models/book.dart';

import '../models/book.dart';

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

            // ---------- IMAGEN PRINCIPAL ----------
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

                  const SizedBox(height: 20),

                  // Título descripción
                  const Text(
                    "Descripción del producto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Descripción
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

                        // 1️⃣ Si no está logueado
                        if (userId == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(fromCart: true),
                            ),
                          );
                          return;
                        }

                        // 2️⃣ Elegir ubicación
                        final selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LocationTabsPage(
                              userId: userId// 👈 IMPORTANTE
                            ),
                          ),
                        );

                        if (selectedLocation == null) return;

                        // 3️⃣ Comprar 1 libro (BACKEND)
                        final result = await AuthService.purchaseSingleBook(
                          userId: userId,
                          bookId: book.id,
                          locationId: selectedLocation.id,
                        );

                        // 4️⃣ Resultado
                        if (result.success) {
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
                                    Navigator.pop(context); // dialog
                                    Navigator.pop(context); // volver
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.message)),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
