import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:harmony/main.dart';

class NetworkUtils {
  static Future<bool> isConnectedNetworks() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      logger.i('Connected to the mobile network');
      return true;
    }
    if (connectivityResult == ConnectivityResult.wifi) {
      logger.i('Connected to the wifi');
      return true;
    }
    if (connectivityResult == ConnectivityResult.ethernet) {
      logger.i('Connected to the ethernet');
      return true;
    }
    if (connectivityResult == ConnectivityResult.vpn) {
      logger.i('Connected to the vpn');
      return true;
    }
    if (connectivityResult == ConnectivityResult.none) {
      logger.i('No available network types');
      return false;
    }
    {
      logger.i('Unknown network type');
      return false;
    }
  }

  static Future<bool> isConnectedBluetooth() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.bluetooth) {
      logger.i('Connected to the bluetooth');
      return true;
    } else {
      logger.i('Not connected to the bluetooth');
      return false;
    }
  }
}