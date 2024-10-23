import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; 
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_bloc.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_event.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_state.dart';
import 'package:flutter_harry_potter/presentation/widgets/filters_widget.dart';
import 'package:flutter_harry_potter/presentation/widgets/character_list_widget.dart';
import 'package:flutter_harry_potter/domain/entities/character.dart';
import 'package:flutter_harry_potter/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_harry_potter/presentation/blocs/login/login_event.dart';
import 'package:flutter_harry_potter/presentation/blocs/theme/theme_bloc.dart'; 
import 'package:flutter_harry_potter/presentation/blocs/theme/theme_event.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharactersScreen> {
  String _filter = '';
  String _selectedHouse = 'Todas';
  String _selectedSpecies = '';
  String _selectedDateOfBirth = '';
  bool isDarkTheme = false;
  Color selectedColor = Colors.blueGrey;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    context.read<CharacterBloc>().add(
          LoadCharactersEvent(
            _filter,
            _selectedHouse != 'Todas' ? _selectedHouse : '',
            _selectedSpecies.isNotEmpty ? _selectedSpecies : '',
            _selectedDateOfBirth,
          ),
        );
  }

  void _showCharacterDetails(BuildContext context, Character character) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                character.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Edad: ${_calculateAge(character.dateOfBirth)} años'),
              const SizedBox(height: 8),
              Text('Familia: ${_getFamily(character.name)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime _convertToDate(String dateOfBirth) {
    final parts = dateOfBirth.split('-');
    if (parts.length == 3) {

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    }
    throw FormatException("Invalid date format");
  }

  dynamic _calculateAge(String dateOfBirth) {
    try {
      DateTime birthDate = _convertToDate(dateOfBirth);
      final today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print("Error al calcular la edad: $e");
      return '?';
    }
  }

  String _getFamily(String name) {
    final parts = name.split(' ');

    if (parts.length > 1) {
      return parts[1];
    }

    return 'Familia desconocida'; 
  }

  String _colorName(Color color) {
    switch (color) {
      case Colors.blueGrey:
        return 'Ravenclaw';
      case Colors.red:
        return 'Gryffindor';
      case Colors.green:
        return 'Slytherin';
      case Colors.yellow:
        return 'Hufflepuff';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          margin: const EdgeInsets.symmetric(
              vertical: 16.0),
          child: Text(
            'HARRY POTTER CHARACTERS',
            style: TextStyle(
              color: isDarkTheme ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 50,
              fontFamily: 'HarryP',
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.black : Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: isDarkTheme ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              final bool? shouldLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.yellowAccent),
                        const SizedBox(width: 10),
                        Text(
                          'Ready to leave Hogwarts?',
                          style: TextStyle(
                            fontFamily:
                                'HarryP',
                            color: Colors.yellowAccent[700],
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    content: const Text(
                      'Your journey may take you far beyond the magical realm.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          'Stay in the magic',
                          style: TextStyle(
                            fontFamily: 'HarryP',
                            color: Colors.lightGreenAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Leave the wizarding world',
                          style: TextStyle(
                            fontFamily: 'HarryP',
                            color: Colors.redAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout == true) {
                if (context.mounted) {
                  context.read<LoginBloc>().add(LogoutButtonPressed());
                }
                await Future.delayed(const Duration(milliseconds: 300));

                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 108, 107, 109),
      ),
      drawer: Drawer(
        child: Container(
          color: isDarkTheme
              ? const Color.fromARGB(255, 0, 0, 0)
              : const Color.fromARGB(
                  255, 255, 255, 255),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 108, 107, 109),
                ),
                child: Text(
                  'Enchantment Configurations',
                  style: TextStyle(
                    color: isDarkTheme
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 40,
                    fontFamily: 'HarryP',
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Dark Arts Mode',
                  style: TextStyle(
                    fontFamily: 'HarryP',
                    fontSize: 30,
                    color: isDarkTheme
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                trailing: Switch(
                  value: isDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      isDarkTheme = value;
                      if (isDarkTheme) {
                        context.read<ThemeBloc>().add(SetDarkTheme());
                      } else {
                        context.read<ThemeBloc>().add(SetLightTheme());
                      }
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'House Color',
                  style: TextStyle(
                    fontFamily: 'HarryP',
                    fontSize: 30,
                    color: isDarkTheme
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                trailing: DropdownButton<Color>(
                  dropdownColor: isDarkTheme
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 248, 248, 248),
                  value: selectedColor,
                  onChanged: (Color? value) {
                    setState(() {
                      selectedColor = value!;
                      context
                          .read<ThemeBloc>()
                          .add(SetThemeColor(selectedColor));
                    });
                  },
                  items: <Color>[
                    Colors.blueGrey, // Ravenclaw
                    Colors.red, // Gryffindor
                    Colors.green, // Slytherin
                    Colors.yellow, // Hufflepuff
                  ].map<DropdownMenuItem<Color>>((Color value) {
                    return DropdownMenuItem<Color>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            color: value,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _colorName(value),
                            style: TextStyle(
                              color: isDarkTheme
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'HarryP',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          return Column(
            children: [
              FiltersWidget(
                name: _filter,
                selectedHouse: _selectedHouse,
                selectedSpecies: _selectedSpecies,
                selectedDateOfBirth: _selectedDateOfBirth,
                speciesList: state.uniqueSpecies,
                onFiltersChanged: (name, house, species, dateOfBirth) {
                  setState(() {
                    _filter = name;
                    _selectedHouse = house;
                    _selectedSpecies = species;
                    _selectedDateOfBirth = dateOfBirth;
                    _applyFilters();
                  });
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Total de personajes: ${state.characters.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage.isNotEmpty) {
                      return Center(child: Text(state.errorMessage));
                    } else if (state.characters.isNotEmpty) {
                      return CharacterListWidget(
                        characters: state.characters,
                        onCharacterTap: (character) {
                          _showCharacterDetails(context, character);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                            'No hay personajes que coincidan con el filtro.'),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
