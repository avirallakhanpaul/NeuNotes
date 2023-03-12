import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neunotes/custom/colors.dart';

class ThemeService extends GetxController {
  final ThemeData lightThemeData = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appBarLight,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: neuBackground,
    fontFamily: "CabinetGrotesk",
  );

  final ThemeData darkThemeData = ThemeData(
    appBarTheme: const AppBarTheme(
      color: appBarDark,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: neuBackgroundDark,
    fontFamily: "CabinetGrotesk",
  );
}
