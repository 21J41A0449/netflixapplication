class Movie {
  final String name;
  final String? image;
  final String? summary;
  final String? language;
  final double? rating;

  Movie({
    required this.name,
    this.image,
    this.summary,
    this.language,
    this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'] ?? 'Unknown',
      image: json['image']?['medium'],
      summary: json['summary'],
      language: json['language'],
      rating: json['rating']?['average'],
    );
  }
}
