import 'package:flutter/material.dart';
import '/services/payment_method_service.dart';
import '/core/utils/card_utils.dart';

class AddPaymentMethodPage extends StatefulWidget {
  final int userId;
  final VoidCallback? onSaved;

  const AddPaymentMethodPage({
    super.key,
    required this.userId,
    this.onSaved,
  });

  @override
  State<AddPaymentMethodPage> createState() =>
      _AddPaymentMethodPageState();
}


class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final cardController = TextEditingController();
  String detectedBrand = 'unknown';
  bool loading = false;

  Future<void> save() async {
    final card = cardController.text.replaceAll(' ', '');
    if (card.length < 12 || detectedBrand == 'unknown') return;

    final last4 = card.substring(card.length - 4);

    setState(() => loading = true);

    try {
      await PaymentMethodService.addMethod(
        userId: widget.userId,
        brand: detectedBrand,
        last4: last4,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar tarjeta')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar tarjeta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cardController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  detectedBrand = detectCardBrand(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Número de tarjeta',
                prefixIcon: detectedBrand != 'unknown'
                    ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/cards/$detectedBrand.png',
                    width: 30,
                  ),
                )
                    : const Icon(Icons.credit_card),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : save,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
