import 'dart:io' show Platform;

class AppConstants {
  static String placesApiKey = _getApiKey();

  static String _getApiKey() {
    if (Platform.isAndroid) {
      return "AIzaSyD-pcvzm3Vvtlmtlz5S1uygCUZqmHWz1Kw";
    } else if (Platform.isIOS) {
      return "AIzaSyCSnz0oIrrQicY1CInrw9MTclI6YenoGaE";
    }

    throw new Exception("API key for current platform not found");
  }
}
