class Movie {
  bool favorite;
  int? id;
  final String title;
  String? imagePath;

  Movie({
    this.id,
    required this.title,
    this.imagePath,
    this.favorite = false,
  });

  Movie.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        favorite = (map['favorite'] ?? false),
        title = map['title'],
        imagePath = map['poster_path'];

  void setFavorite() {
    favorite = !favorite;
  }
}
