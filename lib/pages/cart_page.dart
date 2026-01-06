import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libreria_fatine/models/book.dart';
import 'package:libreria_fatine/models/cart.dart';
import 'package:libreria_fatine/pages/login_page.dart';
import 'package:libreria_fatine/services/auth_service.dart';
import 'package:libreria_fatine/pages/location/location_tabs_page.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrito de Compras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: cart.items.isEmpty
          ? const Center(
        child: Text('Tu carrito está vacío'),
      )
          : ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          Book book = cart.items[index];
          return ListTile(
            leading: Image.network(
              book.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(book.title),
            subtitle: Text('\$${book.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cart.remove(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${book.title} eliminado del carrito'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
            onPressed: () async {
              final userId = await AuthService.getUserId();

              if (userId == null) {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(fromCart: true),
                  ),
                );
                return;
              }

              final firstBook = cart.items.first;

              final purchased = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationTabsPage(
                    userId: userId,
                    book: firstBook, // 👈 CLAVE
                  ),
                ),
              );

              if (!context.mounted) return;

              if (purchased == true) {
                final totalBooks = cart.items.length;
                final totalPrice = cart.totalPrice;

                cart.clear(); // ahora sí

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Compra completada'),
                    content: Text(
                      'Libros: $totalBooks\n'
                          'Total: \$${totalPrice.toStringAsFixed(2)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // dialog
                          Navigator.pop(context); // carrito
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          child: Text('Pagar (\$${cart.totalPrice.toStringAsFixed(2)})'),
        ),
      ),
    );
  }
}



