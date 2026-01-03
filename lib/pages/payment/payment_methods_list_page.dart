import 'package:flutter/material.dart';
import '/services/payment_method_service.dart';
import '/services/purchase_service.dart';
import '/models/payment_method.dart';
import '/models/book.dart';

class PaymentMethodsListPage extends StatelessWidget {
  final int userId;
  final int locationId;
  final Book book;

  const PaymentMethodsListPage({
    super.key,
    required this.userId,
    required this.locationId,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PaymentMethod>>(
      future: PaymentMethodService.getMethods(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay métodos de pago'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final method = snapshot.data![index];

            return ListTile(
              leading: Image.asset(
                'assets/cards/${method.brand}.png',
                width: 36,
              ),
              title: Text('**** **** **** ${method.last4}'),
              subtitle: Text(method.brand.toUpperCase()),
              onTap: () async {
                final res =
                await PurchaseService.purchaseSingleBook(
                  userId: userId,
                  bookId: book.id,
                  locationId: locationId,
                  paymentMethodId: method.id,
                );

                if (res.success && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            );
          },
        );
      },
    );
  }
}
