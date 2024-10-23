import 'package:flutter/material.dart';

class NameFilterWidget extends StatelessWidget {
  final String name;
  final Function(String) onNameChanged;

  const NameFilterWidget({
    super.key,
    required this.name,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nombre:'),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Filtrar por nombre',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onNameChanged(
                value);
          },
        ),
      ],
    );
  }
}

class HouseFilterWidget extends StatelessWidget {
  final String selectedHouse;
  final Function(String) onHouseChanged;

  const HouseFilterWidget({
    super.key,
    required this.selectedHouse,
    required this.onHouseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedHouse,
      onChanged: (value) {
        if (value != null) {
          onHouseChanged(value);
        }
      },
      items: const [
        DropdownMenuItem(value: 'Todas', child: Text('Todas las Casas')),
        DropdownMenuItem(value: 'Gryffindor', child: Text('Gryffindor')),
        DropdownMenuItem(value: 'Slytherin', child: Text('Slytherin')),
        DropdownMenuItem(value: 'Hufflepuff', child: Text('Hufflepuff')),
        DropdownMenuItem(value: 'Ravenclaw', child: Text('Ravenclaw')),
      ].toList()
        ..sort((a, b) => a.child.toString().compareTo(b.child.toString())),
    );
  }
}

class SpeciesFilterWidget extends StatelessWidget {
  final String selectedSpecies;
  final List<String> speciesList;
  final Function(String) onSpeciesChanged;

  const SpeciesFilterWidget({
    super.key,
    required this.selectedSpecies,
    required this.speciesList,
    required this.onSpeciesChanged,
  });

  @override
  Widget build(BuildContext context) {

    final List<String> allSpeciesList = ['Todas las Especies'] + speciesList;

    return DropdownButton<String>(
      value: selectedSpecies.isEmpty ? null : selectedSpecies,
      hint: const Text('Seleccione una Especie'),
      onChanged: (value) {
        if (value != null) {
          onSpeciesChanged(value == 'Todas las Especies'
              ? ''
              : value); 
        }
      },
      items: allSpeciesList.map((species) {
        return DropdownMenuItem(
          value: species,
          child: Text(
            species,
          ),
        );
      }).toList()
        ..sort((a, b) => a.value.toString().compareTo(b.value.toString())),
    );
  }
}

class DateOfBirthFilterWidget extends StatelessWidget {
  final String selectedDateOfBirth;
  final bool isUnknownDateOfBirth;
  final List<String> days;
  final List<String> months;
  final List<String> years;
  final Function(String) onDateOfBirthChanged;
  final Function(bool) onUnknownDateChanged;

  const DateOfBirthFilterWidget({
    super.key,
    required this.selectedDateOfBirth,
    required this.isUnknownDateOfBirth,
    required this.days,
    required this.months,
    required this.years,
    required this.onDateOfBirthChanged,
    required this.onUnknownDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDay =
        selectedDateOfBirth.isNotEmpty && selectedDateOfBirth != 'Desconocido'
            ? selectedDateOfBirth.split('/')[0]
            : null;
    final selectedMonth =
        selectedDateOfBirth.isNotEmpty && selectedDateOfBirth != 'Desconocido'
            ? selectedDateOfBirth.split('/')[1]
            : null;
    final selectedYear =
        selectedDateOfBirth.isNotEmpty && selectedDateOfBirth != 'Desconocido'
            ? selectedDateOfBirth.split('/')[2]
            : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: isUnknownDateOfBirth,
          onChanged: (value) {
            if (value != null) {
              onUnknownDateChanged(
                  value);
            }
          },
        ),
        const Text('Desconocido'),
        const SizedBox(width: 10),
        if (!isUnknownDateOfBirth) ...[
          DropdownButton<String>(
            value: selectedDay,
            hint: const Text('Día'),
            onChanged: (value) {
              if (value != null) {
                final newDateOfBirth =
                    '$value/${selectedMonth ?? ''}/${selectedYear ?? ''}';
                onDateOfBirthChanged(newDateOfBirth);
              }
            },
            items: days.map((day) {
              return DropdownMenuItem(
                value: day,
                child: Text(day),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),

          DropdownButton<String>(
            value: selectedMonth,
            hint: const Text('Mes'),
            onChanged: (value) {
              if (value != null) {
                final newDateOfBirth =
                    '${selectedDay ?? ''}/$value/${selectedYear ?? ''}';
                onDateOfBirthChanged(newDateOfBirth);
              }
            },
            items: months.map((month) {
              return DropdownMenuItem(
                value: month,
                child: Text(month),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),

          DropdownButton<String>(
            value: selectedYear,
            hint: const Text('Año'),
            onChanged: (value) {
              if (value != null) {
                final newDateOfBirth =
                    '${selectedDay ?? ''}/${selectedMonth ?? ''}/$value';
                onDateOfBirthChanged(newDateOfBirth);
              }
            },
            items: years.map((year) {
              return DropdownMenuItem(
                value: year,
                child: Text(year),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class FiltersWidget extends StatelessWidget {
  final String name;
  final String selectedHouse;
  final String selectedSpecies;
  final String selectedDateOfBirth;
  final List<String> speciesList;
  final Function(String, String, String, String) onFiltersChanged;

  const FiltersWidget({
    super.key,
    required this.name,
    required this.selectedHouse,
    required this.selectedSpecies,
    required this.selectedDateOfBirth,
    required this.speciesList,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isUnknownDateOfBirth = selectedDateOfBirth == 'Desconocido';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameFilterWidget(
            name: name,
            onNameChanged: (value) => onFiltersChanged(
              value,
              selectedHouse,
              selectedSpecies,
              selectedDateOfBirth,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: HouseFilterWidget(
                  selectedHouse: selectedHouse,
                  onHouseChanged: (value) => onFiltersChanged(
                    name,
                    value,
                    selectedSpecies,
                    selectedDateOfBirth,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SpeciesFilterWidget(
                  selectedSpecies: selectedSpecies,
                  speciesList: speciesList,
                  onSpeciesChanged: (value) => onFiltersChanged(
                    name,
                    selectedHouse,
                    value,
                    selectedDateOfBirth,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DateOfBirthFilterWidget(
            selectedDateOfBirth: selectedDateOfBirth,
            isUnknownDateOfBirth: isUnknownDateOfBirth,
            days: List.generate(
                31, (index) => (index + 1).toString().padLeft(2, '0')),
            months: List.generate(
                12, (index) => (index + 1).toString().padLeft(2, '0')),
            years: List.generate(
                100,
                (index) =>
                    (2024 - index).toString()),
            onDateOfBirthChanged: (value) => onFiltersChanged(
              name,
              selectedHouse,
              selectedSpecies,
              value,
            ),
            onUnknownDateChanged: (value) => onFiltersChanged(
              name,
              selectedHouse,
              selectedSpecies,
              value
                  ? 'Desconocido'
                  : '',
            ),
          ),
        ],
      ),
    );
  }
}
