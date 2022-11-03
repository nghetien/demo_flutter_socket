import 'package:network_info_plus/network_info_plus.dart';

class WifiSetup {
  static const $port = 4000;
  static String $ip = '';
  static String $subnet = '';

  static Future setIp() async {
    final info = NetworkInfo();

    var wifiName = await info.getWifiName(); // "FooNetwork"
    var wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
    var wifiIP = await info.getWifiIP(); // 192.168.1.43
    var wifiIPv6 = await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
    var wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
    var wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
    var wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1
    print('wifiName $wifiName');
    print('wifiBSSID $wifiBSSID');
    print('wifiIP $wifiIP');
    print('wifiIPv6 $wifiIPv6');
    print('wifiSubmask $wifiSubmask');
    print('wifiBroadcast $wifiBroadcast');
    print('wifiGateway $wifiGateway');
    // $ip = await NetworkInfo().getWifiIP() ?? $ip;
    // if($ip.isNotEmpty) {
    //   $subnet = $ip.substring(0, $ip.lastIndexOf('.'));
    // }
    $ip = '192.168.182.29';
    $subnet = '192.168.182';
  }
}
