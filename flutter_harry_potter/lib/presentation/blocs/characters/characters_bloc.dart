import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_harry_potter/domain/entities/character.dart';
import 'package:flutter_harry_potter/domain/usecases/get_all_characters_usecase.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_event.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetAllCharacters getAllCharacters;

  CharacterBloc(this.getAllCharacters) : super(CharacterState.initial()) {
    on<LoadCharactersEvent>(_onLoadCharacters);
  }

  List<String> extractUniqueSpecies(List<Character> characters) {
    return characters
        .map((character) => character.species)
        .where((species) => species.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _onLoadCharacters(
    LoadCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, filter: event.filter));

    final result = await getAllCharacters();

    result.fold(

      (error) => emit(
          state.copyWith(isLoading: false, errorMessage: error.toString())),

      (characters) {
        final filteredCharacters = characters.where((character) {
          bool matchesName =
              character.name.toLowerCase().contains(event.filter.toLowerCase());

          bool matchesHouse = event.selectedHouse.isEmpty ||
              character.house.toLowerCase() ==
                  event.selectedHouse.toLowerCase();

          bool matchesSpecies = event.selectedSpecies.isEmpty ||
              character.species.toLowerCase() ==
                  event.selectedSpecies.toLowerCase();

          bool matchesDateOfBirth = event.selectedDateOfBirth.isEmpty ||
              character.dateOfBirth == event.selectedDateOfBirth;

          return matchesName &&
              matchesHouse &&
              matchesSpecies &&
              matchesDateOfBirth;
        }).toList();

        final uniqueSpecies = extractUniqueSpecies(characters);

        emit(state.copyWith(
          isLoading: false,
          characters: filteredCharacters,
          uniqueSpecies: uniqueSpecies,
        ));
      },
    );
  }
}
