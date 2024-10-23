class CharacterModel {
  final String name;
  final String house;
  final String image;
  final String species;
  final String dateOfBirth;
  
  CharacterModel(
      {required this.name,
      required this.house,
      required this.image,
      required this.species,
      required this.dateOfBirth});

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      name: json['name'] ?? 'Unknown',
      house: json['house'] ?? 'Unknown',
      image: json['image'] ?? 'Unknown',
      species: json['species'] ?? 'Unknown',
      dateOfBirth: json['dateOfBirth'] ?? 'Unknown',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'house': house,
      'image': image,
      'species': species,
      'dateOfBirth': dateOfBirth,
    };
  }
}
