import 'package:desafio/cubit/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/movie_repository.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(InitialState(false)) {
    getMovieBr();
  }

  void like() {
    state.isFavorite = true;
    emit(state);
  }

  void getMovieBr() async {
    try {
      emit(LoadingState(false));
      final movies = await MovieRepository.loadingMovie();
      emit(LoadedState(movies));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
