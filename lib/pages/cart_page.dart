import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libreria_fatine/models/book.dart';
import 'package:libreria_fatine/models/cart.dart';


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
          onPressed: () {
            // Aquí podrías agregar la funcionalidad de "pagar"
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Compra completada'),
                content: Text(
                    'Has comprado ${cart.items.length} libro(s) por \$${cart.totalPrice.toStringAsFixed(2)}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      cart.clear();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  )
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
