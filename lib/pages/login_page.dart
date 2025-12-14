import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/auth_service.dart';
import 'location/location_tabs_page.dart';
import '/services/location_service.dart';
import 'register_page.dart';


class LoginPage extends StatefulWidget {
  final bool fromCart; // si viene de intentar comprar
  const LoginPage({super.key, this.fromCart = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("http://192.168.1.35/api/login.php");
    final res = await http.post(url, body: {
      "email": email,
      "password": pass,
    });

    setState(() => isLoading = false);

    if (res.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de servidor")),
      );
      return;
    }

    final data = jsonDecode(res.body);

    if (data["success"] == true) {
      final user = data["user"];
      final userId = int.parse(user["id"].toString());

      await AuthService.saveSession(
        id: user["id"].toString(),
        name: user["name"],
        email: user["email"].toString(),
        hasLocation: user["has_location"] == 1,
      );

      // Ver si tiene ubicación
      if (user["has_location"] == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LocationTabsPage(userId: userId),
          ),
        );
      } else {
        Navigator.pop(context, true); // ya tenía ubicación
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Credenciales incorrectas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        automaticallyImplyLeading: widget.fromCart,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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

            // 🔹 BOTÓN ENTRAR
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text("Entrar", style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 16),

            // 🔹 CREAR CUENTA
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tienes cuenta? "),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Crear cuenta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
