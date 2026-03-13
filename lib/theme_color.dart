import 'package:flutter/material.dart';

class ThemeColor {
  final int? themeNumber;
  final BuildContext context;

  ThemeColor({this.themeNumber, required this.context});

  Brightness get _effectiveBrightness {
    switch (themeNumber) {
      case 1:
        return Brightness.light;
      case 2:
        return Brightness.dark;
      default:
        return Theme.of(context).brightness;
    }
  }

  bool get _isLight => _effectiveBrightness == Brightness.light;

  Color get mainBackColor => _isLight ? Color.fromRGBO(255, 255, 255, 1.0) : Color.fromRGBO(17, 17, 17, 1.0);
  Color get mainForeColor => _isLight ? Color.fromRGBO(136, 136, 136, 1.0) : Color.fromRGBO(136, 136, 136, 1.0);
  Color get mainButtonBackColor => _isLight ? Color.fromRGBO(84, 75, 163, 0.8) : Color.fromRGBO(26, 0, 104,0.8);
  Color get mainButtonForeColor => _isLight ? Color.fromRGBO(255, 255, 255, 1.0) : Color.fromRGBO(255, 255, 255, 0.7);
  //
  Color get backColor => _isLight ? Colors.grey[200]! : Colors.grey[900]!;
  Color get cardColor => _isLight ? Colors.white : Colors.grey[800]!;
  Color get appBarForegroundColor => _isLight ? Colors.grey[700]! : Colors.white70;
  Color get dropdownColor => cardColor;
  Color get backColorMono => _isLight ? Colors.white : Colors.black;
  Color get foreColorMono => _isLight ? Colors.black : Colors.white;

}
