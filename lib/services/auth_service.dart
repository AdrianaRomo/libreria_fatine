import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config/api_config.dart';

class PurchaseResponse {
  final bool success;
  final String message;

  PurchaseResponse({required this.success, required this.message});
}

class AuthService {
  static const String keyUserId = "user_id";
  static const String keyUserName = "user_name";
  static const String keyUserEmail = "user_email";
  static const String keyHasLocation = "has_location";

  // Guardar sesión
  static Future<void> saveSession({
    required String id,
    required String name,
    required String email,
    required bool hasLocation,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserId, id);
    await prefs.setString(keyUserName, name);
    await prefs.setString(keyUserEmail, email);
    await prefs.setBool(keyHasLocation, hasLocation);
  }

  // Obtener ID de usuario
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return int.tryParse(prefs.getString(keyUserId) ?? '');
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserEmail);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserName);
  }

  // Saber si tiene ubicación
  static Future<bool> hasLocation() async {
    final userId = await AuthService.getUserId();

    // Si no hay sesión
    if (userId == null) return false;

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/get_locations.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    // Debug por si algo falla
    // print(response.body);

    if (response.statusCode != 200) {
      return false;
    }

    final data = jsonDecode(response.body);

    // get_locations.php devuelve ARRAY
    if (data is List) {
      return data.isNotEmpty;
    }
    return false;
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<PurchaseResponse> purchaseSingleBook({
    required int userId,
    required int bookId,
    required int locationId,
  }) async {

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/purchase_book.php",
    );

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "book_id": bookId,
        "quantity": 1,
        "location_id": locationId,
      }),
    );

    final data = jsonDecode(res.body);
    return PurchaseResponse(
      success: data['success'],
      message: data['message'],
    );
  }
}