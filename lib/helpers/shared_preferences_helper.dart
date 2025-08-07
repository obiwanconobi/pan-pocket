import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  // To set a string value
  static Future<bool> setString(String key, String value) {
    return _sharedPreferences!.setString(key, value);
  }

  // To get a string value
  static String? getString(String key) {
    return _sharedPreferences!.getString(key);
  }

  static Future<bool> setInt(String key, int value){
    return _sharedPreferences!.setInt(key, value);
  }

  // To get a string value
  static int? getInt(String key) {
    return _sharedPreferences!.getInt(key);
  }

  static bool? getBool(String clearCache){
    return _sharedPreferences!.getBool(clearCache);
  }

  static Future<bool> setBool(String key, bool value){
    return _sharedPreferences!.setBool(key, value);
  }

// Similarly, you can create methods for other data types.
}