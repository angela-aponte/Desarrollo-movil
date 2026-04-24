import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static String get accidentsApiBaseUrl {
    final envValue = dotenv.env['ACCIDENTS_API_BASE_URL'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim();
    }
    return 'https://www.datos.gov.co/resource/ezt8-5wyj.json';
  }

  static String get parkingApiBaseUrl {
    final envValue = dotenv.env['PARKING_API_BASE_URL'];
    if (envValue != null && envValue.trim().isNotEmpty) {
      return envValue.trim();
    }
    return 'https://parking.visiontic.com.co/api';
  }
}