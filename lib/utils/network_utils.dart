import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:harmony/main.dart';

class NetworkUtils {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      logger.i('Connected to the mobile network');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      logger.i('Connected to the wifi');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      logger.i('Connected to the ethernet');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.vpn)) {
      logger.i('Connected to the vpn');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      logger.i('Connected to the bluetooth');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.other)) {
      logger.i(
          'Connected to a network which is not in the above mentioned networks');
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.none)) {
      logger.i('No available network types');
      return false;
    }
    {
      logger.i('Unknown network type');
      return false;
    }
  }
}
