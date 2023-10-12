import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;
  static const String isUserLoggedIn = 'isuserloggedin';
  static const String isToken = 'Token';
  static const String userDataLocal = 'userData';
  static const String isRefreshToken = 'refresh_token';
  static const String isFingerprint = 'true';
  static const String weburl = 'weburl';
  static const String devurl = 'devurl';
  static const String currency = 'currency';
  static const String fcmToken = 'fcmToken';
  static const String uniquecode = 'uniquecode';
  static const String notificationStatus = 'notification';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setLoginStatus({required bool loginStatus}) async {
    await _preferences.setBool(isUserLoggedIn, loginStatus);
  }

  static bool? getLoginStatus() {
    return _preferences.getBool(isUserLoggedIn);
  }

  static Future setNotificationStatus({required bool status}) async {
    await _preferences.setBool(notificationStatus, status);
  }

  static bool? getNotificationStatus() {
    return _preferences.getBool(notificationStatus);
  }

  static Future setWebUrl({required String userData}) async {
    await _preferences.setString(weburl, userData);
  }

  static String? getWebUrl() {
    return (_preferences.getString(weburl));
  }

  static Future setDevUrl({required String userData}) async {
    await _preferences.setString(devurl, userData);
  }

  static String? getDevUrl() {
    return (_preferences.getString(devurl));
  }

  static Future setCurrency({required String money}) async {
    await _preferences.setString(currency, money);
  }

  static String? getCurrency() {
    return (_preferences.getString(currency));
  }

  static Future setfcmToken(String? token) async {
    await _preferences.setString(fcmToken, token!);
  }

  static String? getfcmToken() {
    return (_preferences.getString(fcmToken));
  }

  static Future setuniquecode(String? identifier) async {
    await _preferences.setString(uniquecode, identifier!);
  }

  static String? getuniquecode() {
    return (_preferences.getString(uniquecode));
  }

  static Future setUserdata({required String userData}) async {
    await _preferences.setString(userDataLocal, userData);
  }

  static String? getUserdata() {
    return (_preferences.getString(userDataLocal));
  }

  static Future setfingerprintdata({required String userData}) async {
    await _preferences.setString(isFingerprint, userData);
  }

  static Future setRefreshToken({required String refreshToken}) async {
    await _preferences.setString(isRefreshToken, refreshToken);
  }

  static String? getRefreshToken() {
    return _preferences.getString(isRefreshToken);
  }

  static String? getfingerprintdata() {
    return (_preferences.getString(isFingerprint));
  }

  static Future setToken({required String token}) async {
    await _preferences.setString(isToken, token);
  }

  static String? getToken() {
    return _preferences.getString(isToken);
  }

  static void clearAllData() {
    _preferences.clear();
  }
}
