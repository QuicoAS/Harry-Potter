import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCharactersEvent extends CharacterEvent {
  final String filter;

  final String selectedHouse;

  final String selectedSpecies;

  final String selectedDateOfBirth;

  LoadCharactersEvent(this.filter, this.selectedHouse, this.selectedSpecies,
      this.selectedDateOfBirth);

  @override
  List<Object?> get props =>
      [filter, selectedHouse, selectedSpecies, selectedDateOfBirth];
}
