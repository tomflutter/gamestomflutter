class Game {
  final int id;
  final String name;
  final String backgroundImage;
  String description;
  final String? releaseDate;
  final double? rating;
  final List<String>? genres;
  final List<String>? platforms;
  final String? website;
  final int playtime;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.description,
    this.releaseDate,
    this.rating,
    this.genres,
    this.platforms,
    this.website,
    required this.playtime,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    List<String> platformsList = [];
    if (json['platforms'] != null) {
      for (var platform in json['platforms']) {
        platformsList.add(platform['platform']['name'] ?? 'Unknown Platform');
      }
    }

    return Game(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['background_image'] ?? '',
      description: json['description'] ?? 'Description not available',
      releaseDate: json['released'],
      rating: json['rating']?.toDouble(),
      genres: json['genres']?.map<String>((e) => e['name'] as String).toList(),
      platforms: platformsList.isEmpty ? null : platformsList,
      website: json['website'],
      playtime: json['playtime'] ?? 0,
    );
  }
}
