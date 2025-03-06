/*
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceIdHelper {
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedDeviceId = prefs.getString('device_id');

    if (savedDeviceId != null) {
      return savedDeviceId;
    }

    final deviceInfo = DeviceInfoPlugin();
    String newDeviceId;

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      newDeviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      newDeviceId = iosInfo.identifierForVendor ?? 'unknown_ios_device';
    } else {
      throw Exception("Unknown Platform");
    }

    await prefs.setString('device_id', newDeviceId);
    return newDeviceId;
  }
}
 */