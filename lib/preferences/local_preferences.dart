import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static Future<void> saveIP(String id) async {
    await instance.setString(
      "IP",
      id,
    );
    log('Ip saved to localstorage $id');
  }

  static String? getIP() {
    return instance.getString(
      "IP",
    );
  }

  static Future<void> clear() async {
    await instance.clear();
  }
}
