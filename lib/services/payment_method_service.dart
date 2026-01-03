import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/payment_method.dart';
import '/core/config/api_config.dart';

class PaymentMethodService {

  /// Obtener métodos de pago del usuario
  static Future<List<PaymentMethod>> getMethods(int userId) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/get_payment_methods.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (res.statusCode != 200) {
      throw Exception('Error al obtener métodos de pago');
    }

    final List data = json.decode(res.body);
    return data.map((e) => PaymentMethod.fromJson(e)).toList();
  }

  /// Agregar metodo de pago
  static Future<bool> addMethod({
    required int userId,
    required String brand,
    required String last4,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/add_payment_method.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'brand': brand,
        'last4': last4,
      }),
    );

    return res.statusCode == 200;
  }
}

