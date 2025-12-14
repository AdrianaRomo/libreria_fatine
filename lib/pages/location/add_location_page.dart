import 'package:flutter/material.dart';
import '/services/location_service.dart';

class AddLocationPage extends StatefulWidget {
  final int userId;

  const AddLocationPage({super.key, required this.userId});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // GPS (luego lo cambias por geolocator)
  double lat = 19.4326;
  double lng = -99.1332;

  // Controllers
  final streetCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final colonyCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final referenceCtrl = TextEditingController();

  Future<void> saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final addressData = {
      'street': streetCtrl.text,
      'number': numberCtrl.text,
      'colony': colonyCtrl.text,
      'city': cityCtrl.text,
      'postal_code': postalCtrl.text,
      'reference': referenceCtrl.text,
    };

    final success = await LocationService.saveLocation(
      widget.userId,
      lat,
      lng,

    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Dirección guardada correctamente' : 'Error al guardar',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    streetCtrl.dispose();
    numberCtrl.dispose();
    colonyCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    referenceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _input(streetCtrl, 'Calle'),
            _input(numberCtrl, 'Número'),
            _input(colonyCtrl, 'Colonia'),
            _input(cityCtrl, 'Ciudad'),
            _input(
              postalCtrl,
              'Código Postal',
              keyboard: TextInputType.number,
            ),
            _input(referenceCtrl, 'Referencia (opcional)', required: false),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar dirección'),
              onPressed: saveLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      String label, {
        bool required = true,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: required
            ? (value) =>
        value == null || value.isEmpty ? 'Campo requerido' : null
            : null,
      ),
    );
  }
}
