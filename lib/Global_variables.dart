
class globalvariables {
  // URLs
  static const String _production = 'https://2451dv8v-5000.asse.devtunnels.ms/api';
  // Replace with your machine's LAN IP if testing on a real device
  static const String _local = 'https://2451dv8v-5000.asse.devtunnels.ms/api';
  // Android emulator sees host machine at 10.0.2.2
  //static const String _androidEmulator = 'http://10.0.2.2:5000/api';

  // Get the appropriate base URL based on environment & platform
  String getBaseUrl() {
    return _production;
  }
}
