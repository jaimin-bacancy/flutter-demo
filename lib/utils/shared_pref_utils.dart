import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  SharedPrefUtils._();

  static final SharedPrefUtils instance = SharedPrefUtils._();

  factory SharedPrefUtils() {
    return instance;
  }

  late final SharedPreferences _sharedPreferences;

  Future<SharedPreferences> init() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  T getValue<T>(String key, T defaultValue) {
    dynamic value = _sharedPreferences.get(key) ?? defaultValue;
    if (value is List) {
      return List.from(value) as T;
    }
    return value as T;
  }

  void setValue(String key, Object value) {
    if (value is int) {
      _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      _sharedPreferences.setDouble(key, value);
    } else if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is List<String>) {
      _sharedPreferences.setStringList(key, value);
    }
  }

  void removeValue(String key) {
    _sharedPreferences.remove(key);
  }

  Future<void> clearSharedPref() async {
    await _sharedPreferences.clear();
  }

  void setUserToken(String token) {
    setValue(SharedPrefUtilsKeys.token, token);
  }

  String getUserToken() {
    String token = getValue(SharedPrefUtilsKeys.token, "");
    return token;
  }
}

class SharedPrefUtilsKeys {
  static String token = 'token';
}
