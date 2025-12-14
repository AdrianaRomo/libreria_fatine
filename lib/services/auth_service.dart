import 'package:shared_preferences/shared_preferences.dart';

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

  // Saber si tiene ubicación
  static Future<bool> hasLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyHasLocation) ?? false;
  }

  // Cerrar sesión
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}