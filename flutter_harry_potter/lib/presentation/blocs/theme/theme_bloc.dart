import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: _lightTheme)) {
    on<SetLightTheme>((event, emit) {
      emit(ThemeState(themeData: _lightTheme));
    });

    on<SetDarkTheme>((event, emit) {
      emit(ThemeState(themeData: _darkTheme));
    });

    on<SetThemeColor>((event, emit) {
      final newTheme = ThemeData(
        brightness: state.themeData.brightness,
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: state.themeData.scaffoldBackgroundColor,
        appBarTheme: AppBarTheme(
          color: event.color,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        drawerTheme: DrawerThemeData(backgroundColor: event.color),
      );
      emit(ThemeState(themeData: newTheme));
    });
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
    ),
  );
}
