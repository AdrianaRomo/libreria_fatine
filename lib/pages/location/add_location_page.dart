import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/auth_service.dart';
import '/core/config/api_config.dart';

class AddLocationPage extends StatefulWidget {
  final int userId;
  final VoidCallback onSaved;

  const AddLocationPage({
    super.key,
    required this.userId,
    required this.onSaved,
  });

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}


class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // Controllers
  final streetCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final colonyCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final referenceCtrl = TextEditingController();

  Future<void> saveLocation() async {
    final street = streetCtrl.text.trim();
    final number = numberCtrl.text.trim();
    final colony = colonyCtrl.text.trim();
    final city = cityCtrl.text.trim();
    final postal = postalCtrl.text.trim();
    final reference = referenceCtrl.text.trim();

    if (street.isEmpty ||
        number.isEmpty ||
        colony.isEmpty ||
        city.isEmpty ||
        postal.isEmpty ||
        reference.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => loading = true);

    // 🔥 AQUÍ ESTÁ LA CLAVE
    final int? userId = await AuthService.getUserId();

    if (userId == null) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sesión no válida")),
      );
      return;
    }

    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/insert_adresses.php"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'uid': userId, // ✅ ya es int
        'street': street,
        'number': number,
        'colony': colony,
        'city': city,
        'postal': postal,
        'reference': reference,
      }),
    );

    setState(() => loading = false);

    print(res.body);
    final data = jsonDecode(res.body);

    if (data["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"] ?? "Ubicación registrada exitosamente"),
        ),
      );
      widget.onSaved(); // 🔥 refresca lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Error al registrar")),
      );
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

