import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return "http://25.6.102.94/api";
    }
    return "http://25.6.102.94/api";
  }
}
