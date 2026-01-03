import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    // Android emulator
    if (Platform.isAndroid) {
      return "http://25.6.102.94/api";
    }
    // Physical device / others
    return "http://25.6.102.94/api";
  }
}
