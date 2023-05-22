import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../support/models/movie.dart';
import '../support/utils/constants.dart';

class FirebasePage extends StatefulWidget {
  const FirebasePage({super.key});

  @override
  State<FirebasePage> createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  late DatabaseReference _dataRef;
  final List<Movie> movies = [];
  bool isLoading = false;

  @override
  void initState() {
    initRef();
    super.initState();
  }

  initRef() async {
    setState(() {
      isLoading = true;
    });

    _dataRef = FirebaseDatabase.instance.ref('movies');

    try {
      final snapshot = await _dataRef.get();

      for (var element in snapshot.children) {
        Map<dynamic, dynamic> map = element.value as Map;
        String key = map.keys.first;
        Movie movie = Movie.fromMap(map[key]);
        setState(() {
          movies.add(movie);
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Curtidos'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                if (movies.isEmpty) {
                  setState(() {});
                  return const Center(
                    child: Text('Lista Vazia'),
                  );
                }
                return Card(
                  child: ListTile(
                    title: Text(movies[index].title),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        Constants.pathImage + (movies[index].imagePath ?? ''),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _dataRef.child(movies[index].id.toString()).remove();

                        setState(() {
                          movies.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
