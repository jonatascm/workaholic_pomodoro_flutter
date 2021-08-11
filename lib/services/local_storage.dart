import 'package:shared_preferences/shared_preferences.dart';

class LocalKeys {
  static const String kFirstLaunch = 'firstLaunch';
  static const String kLaunchToday = 'launchToday';
}

class AppLocalStorage {
  SharedPreferences? _localStorage;

  bool containsKey(String key) => _localStorage?.containsKey(key) ?? false;
  String getString(String key) => _localStorage?.getString(key) ?? '';
  bool getBool(String key) => _localStorage?.getBool(key) ?? false;

  Future<bool> setBool(String key, bool value) => _localStorage?.setBool(key, value) ?? Future.value(false);

  Future<bool> setString(String key, String value) => _localStorage?.setString(key, value) ?? Future.value(false);

  Future initialize() async {
    if (_localStorage != null) {
      return;
    }
    _localStorage = await SharedPreferences.getInstance();
  }

  bool isFirstLanch() {
    return _localStorage?.getBool(LocalKeys.kFirstLaunch) ?? true;
  }

  bool hasOpenToday() {
    String? dateString = _localStorage?.getString(LocalKeys.kLaunchToday);
    if (dateString == null) return false;
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    return date.month == now.month && date.day == now.day && date.year == now.year;
  }

  void setHasOpenToday() {
    DateTime now = DateTime.now();
    String date = "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    _localStorage?.setString(LocalKeys.kLaunchToday, date);
  }

  void setFirstLaunch({bool? overrideValue}) {
    if (overrideValue != null) {
      _localStorage?.setBool(LocalKeys.kFirstLaunch, overrideValue);
      return;
    }

    _localStorage?.setBool(LocalKeys.kFirstLaunch, false);
  }

  Future clearUserAuthData() async {
    //await _localStorage?.remove(LocalKeys.kCREDENTIAL_EMAIL);
  }

  void setCredentials({String? authProvider, String email = '', String password = ''}) {
    //_localStorage?.setString(LocalKeys.kCREDENTIAL_EMAIL, email);
  }
}

final localStorage = AppLocalStorage();
