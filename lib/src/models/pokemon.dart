class Pokemon {
  final int id;
  final int dexId;
  final String name;
  final String image;
  final String primaryType;
  final String description;
  final String secondaryType;
  final bool isMega;

  Pokemon({
      required this.id,
      required this.dexId,
      required this.name,
      required this.image,
      required this.primaryType,
      required this.description,
      required this.secondaryType,
      required this.isMega
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
    id: json['id'],
    dexId: json['dex_id'],
    name: json['name'],
    image: json['image']??"",
    primaryType: json['primary_type'],
    description: json['description']??"",
    secondaryType: json['secondary_type']??"",
    isMega: json['is_mega']
    );
  }
}
