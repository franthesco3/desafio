import 'package:desafio/cubit/movie_cubit.dart';
import 'package:desafio/cubit/movie_state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../support/models/movie.dart';
import '../support/utils/constants.dart';
import 'firebase_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseReference _dataRef;
  final List<Movie> _movies = [];

  @override
  void initState() {
    initRef();
    super.initState();
  }

  initRef() async {
    _dataRef = FirebaseDatabase.instance.ref('movies');

    try {
      final snapshot = await _dataRef.get();
      for (var element in snapshot.children) {
        Map<dynamic, dynamic> map = element.value as Map;
        String key = map.keys.first;
        Movie movie = Movie.fromMap(map[key]);
        setState(() {
          _movies.add(movie);
        });
      }
      print(_movies);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebasePage(),
                  ),
                );
              },
              icon: const Text('Curtidos'),
            ),
          )
        ],
        title: const Text('Filmes Brasileiros'),
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            return const Center(
              child: Icon(Icons.close),
            );
          } else if (state is LoadedState) {
            final movies = state.movies;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(movies[index].title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      Constants.pathImage + (movies[index].imagePath ?? ''),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: movies[index].favorite
                          ? () {
                              _dataRef
                                  .child(movies[index].id.toString())
                                  .remove();
                              setState(() {
                                movies[index].favorite = false;
                              });
                            }
                          : () {
                              setState(() {
                                movies[index].favorite = true;
                              });
                              _dataRef
                                  .child(movies[index].id.toString())
                                  .push()
                                  .set({
                                "id": movies[index].id,
                                "title": movies[index].title,
                                "poster_path": movies[index].imagePath,
                                "favorite": movies[index].favorite,
                              });
                            },
                      icon: const Icon(Icons.favorite),
                      color: colorFavorite(movies[index].favorite)),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void addMovie(Movie movie) {
    _dataRef.child(movie.id.toString()).push().set({
      "id": movie.id,
      "title": movie.title,
      "poster_path": movie.imagePath,
      "favorite": movie.favorite,
    });
  }

  void removeMovie(String id) {
    _dataRef.child('id').remove();
  }

  Color colorFavorite(bool favorite) {
    return favorite ? Colors.red : Colors.grey;
  }
}
