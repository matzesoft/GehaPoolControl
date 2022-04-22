import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static Color customShadowColor(BuildContext context) {
    if (kIsWeb) {
      if (Theme.of(context).brightness == Brightness.light) {
        return Colors.grey.shade200;
      } else {
        return Colors.grey.shade800;
      }
    }
    return Colors.grey.shade100.withOpacity(0.15);
  }

  static double get customElevation => 8.0;
  static double get borderRadius => 16.0;

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        primaryColor: Colors.grey.shade100,
        accentColor: Color(0xFF428DFC),
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        canvasColor: Colors.grey[200],
        cursorColor: Color(0xFF428DFC),
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.black26,
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        hoverColor: Colors.grey[50],
        fontFamily: 'Rubik',
        iconTheme: IconThemeData(color: Colors.grey[500]),
        toggleableActiveColor: Color(0xFF428DFC),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF343A47),
              fontFamily: 'Rubik',
            ),
          ),
          iconTheme: IconThemeData(color: Colors.grey[500]),
          color: Colors.grey[100],
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xFF428DFC),
          unselectedLabelColor: Colors.grey[500],
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        dialogTheme: DialogTheme(
          elevation: customElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade100,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade100,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade100,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          borderRadius: BorderRadius.circular(borderRadius),
          fillColor: Color(0xFF428DFC),
          selectedColor: Color(0xFF428DFC),
          selectedBorderColor: Colors.grey[100],
          borderColor: Colors.grey[100],
          borderWidth: 1.6,
        ),
        textTheme: TextTheme(
          headline2: TextStyle(
            fontSize: 56,
          ),
          headline3: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          headline4: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          headline5: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
          caption: TextStyle(fontSize: 12),
          button: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: Colors.grey[700],
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.blueAccent[100],
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.grey[800],
        cursorColor: Colors.blueAccent[100],
        cardTheme: CardTheme(
          color: Colors.grey[900],
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        hoverColor: Colors.grey[800],
        fontFamily: 'Rubik',
        iconTheme: IconThemeData(color: Colors.grey[400]),
        toggleableActiveColor: Colors.blueAccent[100],
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Rubik'),
            ),
            iconTheme: IconThemeData(color: Colors.grey[400]),
            color: Colors.black),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blueAccent[100],
          unselectedLabelColor: Colors.grey[500],
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        dialogTheme: DialogTheme(
          elevation: customElevation,
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade800,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade800,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 0,
              color: Colors.grey.shade800,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade800,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        toggleButtonsTheme: ToggleButtonsThemeData(
          borderRadius: BorderRadius.circular(20),
          fillColor: Colors.blueAccent[100],
          selectedColor: Colors.blueAccent[100],
          selectedBorderColor: Colors.grey[800],
          borderColor: Colors.grey.shade800.withOpacity(0.5),
          borderWidth: 1.6,
        ),
        textTheme: TextTheme(
          headline2: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w500,
          ),
          headline3: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w500,
            color: Colors.grey[100],
          ),
          headline4: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w500,
            color: Colors.grey[100],
          ),
          headline5: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.grey[100],
          ),
          headline6: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[100],
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[300],
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[300],
          ),
          caption: TextStyle(fontSize: 12),
          button: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      );
}