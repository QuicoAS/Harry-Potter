import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SetLightTheme extends ThemeEvent {}

class SetDarkTheme extends ThemeEvent {}

class SetThemeColor extends ThemeEvent {
  
  final Color color;
  const SetThemeColor(this.color);

  @override
  List<Object> get props => [color];
}












