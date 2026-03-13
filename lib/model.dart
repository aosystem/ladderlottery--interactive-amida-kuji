import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ladderlottery/l10n/app_localizations.dart';

class Model {
  Model._();

  static const String _prefLotteryCount = 'lotteryCount';
  static const String _prefLotterySpeed = 'lotterySpeed';
  static const String _prefSoundVolume = 'soundVolume';
  static const String _prefBackgroundImageNumber = 'backgroundImageNumber';
  static const String _prefThemeNumber = 'themeNumber';
  static const String _prefLanguageCode = 'languageCode';

  static bool _ready = false;
  static int _lotteryCount = 3;
  static int _lotterySpeed = 60;
  static double _soundVolume = 1.0;
  static int _backgroundImageNumber = 1;
  static int _themeNumber = 0;
  static String _languageCode = '';

  static int get lotteryCount => _lotteryCount;
  static int get lotterySpeed => _lotterySpeed;
  static double get soundVolume => _soundVolume;
  static int get backgroundImageNumber => _backgroundImageNumber;
  static int get themeNumber => _themeNumber;
  static String get languageCode => _languageCode;

  static Future<void> ensureReady() async {
    if (_ready) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    _lotteryCount = (prefs.getInt(_prefLotteryCount) ?? 3).clamp(2,9);
    _lotterySpeed = (prefs.getInt(_prefLotterySpeed) ?? 60).clamp(30,300);
    _soundVolume = (prefs.getDouble(_prefSoundVolume) ?? 1.0).clamp(0.0,1.0);
    _backgroundImageNumber = (prefs.getInt(_prefBackgroundImageNumber) ?? 1).clamp(0,10);
    _themeNumber = (prefs.getInt(_prefThemeNumber) ?? 0).clamp(0, 2);
    _languageCode = prefs.getString(_prefLanguageCode) ?? ui.PlatformDispatcher.instance.locale.languageCode;
    _languageCode = _resolveLanguageCode(_languageCode);
    _ready = true;
  }

  static String _resolveLanguageCode(String code) {
    final supported = AppLocalizations.supportedLocales;
    if (supported.any((l) => l.languageCode == code)) {
      return code;
    } else {
      return '';
    }
  }

  static Future<void> setLotteryCount(int value) async {
    _lotteryCount = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefLotteryCount, value);
  }

  static Future<void> setLotterySpeed(int value) async {
    _lotterySpeed = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefLotterySpeed, value);
  }

  static Future<void> setSoundVolume(double value) async {
    _soundVolume = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefSoundVolume, value);
  }

  static Future<void> setBackgroundImageNumber(int value) async {
    _backgroundImageNumber = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefBackgroundImageNumber, value);
  }

  static Future<void> setThemeNumber(int value) async {
    _themeNumber = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefThemeNumber, value);
  }

  static Future<void> setLanguageCode(String value) async {
    _languageCode = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageCode, value);
  }

}
