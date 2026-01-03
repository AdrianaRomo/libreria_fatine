import 'package:flutter/material.dart';
import '/models/book.dart';
import '/pages/payment/payment_methods_list_page.dart';
import '/pages/payment/add_payment_method_page.dart';

class PaymentMethodsTabsPage extends StatefulWidget {
  final int userId;
  final int locationId;
  final Book book;

  const PaymentMethodsTabsPage({
    super.key,
    required this.userId,
    required this.locationId,
    required this.book,
  });

  @override
  State<PaymentMethodsTabsPage> createState() =>
      _PaymentMethodsTabsPageState();
}

class _PaymentMethodsTabsPageState
    extends State<PaymentMethodsTabsPage> {

  int refreshKey = 0;

  void refreshPayments() {
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
          title: const Text('Métodos de pago'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.credit_card),
                text: 'Mis tarjetas',
              ),
              Tab(
                icon: Icon(Icons.add_card),
                text: 'Agregar',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 🟢 LISTA DE TARJETAS
            PaymentMethodsListPage(
              key: ValueKey(refreshKey),
              userId: widget.userId,
              locationId: widget.locationId,
              book: widget.book,
            ),

            // 🟢 AGREGAR TARJETA
            AddPaymentMethodPage(
              userId: widget.userId,
              onSaved: refreshPayments,
            ),
          ],
        ),
      ),
    );
  }
}
