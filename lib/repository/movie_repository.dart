import 'dart:convert';
import '../support/models/movie.dart';
import 'package:http/http.dart' as http;

import '../support/utils/constants.dart';

class MovieRepository {
  static Future<List<Movie>> loadingMovie() async {
    var movies = <Movie>[];
    final url = Uri.parse(Constants.urlMovies);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      movies = List<Movie>.from(
        data['results'].map((movie) => Movie.fromMap(movie)),
      );
      print(movies);
    }
    return movies;
  }
}
