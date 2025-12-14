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

            // Si no está logueado
            if (userId == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(fromCart: true),
                ),
              );
              return;
            }

            //Ir a la pantalla de direcciones
            final selectedLocation = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LocationTabsPage(userId: userId),
              ),
            );

            // Si no seleccionó nada
            if (selectedLocation == null) return;

            // Confirmar compra
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Compra completada'),
                content: Text(
                  'Libros: ${cart.items.length}\n'
                      'Dirección: ${selectedLocation['address']}\n'
                      'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      cart.clear();
                      Navigator.of(context).pop(); // dialog
                      Navigator.of(context).pop(); // carrito
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text('Pagar (\$${cart.totalPrice.toStringAsFixed(2)})'),
        ),
      ),
    );
  }
}



