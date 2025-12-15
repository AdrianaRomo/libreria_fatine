import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/location_model.dart';
import '/config/api_config.dart';

class LocationService {

  static Future<List<LocationModel>> getUserLocations(int userId) async {
    final res = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/get_locations.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => LocationModel.fromJson(e)).toList();
  }

  static Future<bool> saveLocation(int userId, String street, int number, String colony, String city, int postal, String reference) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/save_location.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'street': street,
        'number': number,
        'colony': colony,
        'city': city,
        'postal_code': postal,
        'reference': reference,
      }),
    );

    final data = jsonDecode(response.body);
    return data["status"] == "success";
  }

  static Future<bool> hasLocation(int userId) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/check_user_locations.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);
    if (data["status"] == "success") {
      return data["has_location"] == true;
    }
    return false;
  }
}
