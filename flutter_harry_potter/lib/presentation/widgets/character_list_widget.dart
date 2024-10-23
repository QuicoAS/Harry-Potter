import 'package:flutter/material.dart';
import 'package:flutter_harry_potter/domain/entities/character.dart';

class CharacterListWidget extends StatelessWidget {
  final List<Character> characters;
  final Function(Character) onCharacterTap;

  const CharacterListWidget({
    super.key,
    required this.characters,
    required this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.7,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        return GestureDetector(
          onTap: () => onCharacterTap(character), 
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        character.image.isNotEmpty
                            ? character.image
                            : 'https://media.gettyimages.com/id/2052414/es/foto/this-handout-from-christies-shows-the-cover-of-j-k-rowlings-first-novel-harry-potter-and-the.jpg?s=1024x1024&w=gi&k=20&c=inPb7ZQsnnGFaCyb5Vwandn_FApukqhWq9PIU7-Paiw=',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Casa: ${character.house.isNotEmpty ? character.house[0].toUpperCase() + character.house.substring(1) : 'Desconocido'}',
                  ),
                  Text(
                    'Especie: ${character.species.isNotEmpty ? character.species[0].toUpperCase() + character.species.substring(1) : 'Desconocido'}',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
