import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/auth_service.dart';
import 'location/location_tabs_page.dart';
import '/config/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final lnameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> registerUser() async {
    final name = nameCtrl.text.trim();
    final lname = lnameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (name.isEmpty || lname.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => loading = true);

    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/create_users.php"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "names": name,
        "last_names": lname,
        "email": email,
        "password": pass,
      }),
    );
    setState(() => loading = false);

    print(res.body);
    final data = jsonDecode(res.body);

    if (data["success"] == true) {
      final userId = int.parse(data["user_id"].toString());

      await AuthService.saveSession(
        id: userId.toString(),
        name: name,
        email: email,
        hasLocation: false,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LocationTabsPage(userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Error al registrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear cuenta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lnameCtrl,
              decoration: const InputDecoration(
                labelText: "Apellido",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Correo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : registerUser,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Registrarme"),
            ),
          ],
        ),
      ),
    );
  }
}
