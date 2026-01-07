import 'dart:convert';
import 'package:http/http.dart' as http;
import '/core/config/api_config.dart';

class PurchaseResponse {
  final bool success;
  final String message;

  PurchaseResponse({
    required this.success,
    required this.message,
  });
}

class PurchaseService {

  /// Comprar un solo libro
  static Future<PurchaseResponse> purchaseSingleBook({
    required int userId,
    required int bookId,
    required int locationId,
    required int paymentMethodId,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/purchase_book.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'book_id': bookId,
        'quantity': 1,
        'location_id': locationId,
        'payment_method_id': paymentMethodId,
      }),
    );

    final data = jsonDecode(res.body);

    return PurchaseResponse(
      success: data['success'] ?? false,
      message: data['message'] ?? 'Error desconocido',
    );
  }
}
