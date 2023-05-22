import 'package:equatable/equatable.dart';
import '../support/models/movie.dart';

abstract class MovieState extends Equatable {
  bool isFavorite;

  MovieState(this.isFavorite);
}

class InitialState extends MovieState {
  InitialState(super.isFavorite);

  @override
  List<Object?> get props => [];
}

class LoadingState extends MovieState {
  LoadingState(super.isFavorite);

  @override
  List<Object?> get props => [];
}

class LoadedState extends MovieState {
  LoadedState(this.movies) : super(false);

  final List<Movie> movies;

  @override
  List<Object> get props => [movies];
}

class ErrorState extends MovieState {
  ErrorState() : super(false);

  @override
  List<Object> get props => [];
}
