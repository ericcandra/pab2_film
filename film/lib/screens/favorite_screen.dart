import 'package:film/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? favoriteList = prefs.getStringList('favorites');
  if (favoriteList != null) {
    setState(() {
      favoriteMovies = favoriteList
          .map((movieJson) {
            try {
              return Movie.fromJson(jsonDecode(movieJson));
            } catch (e) {
              print("Error decoding movie: $e");
              return null;
            }
          })
          .where((movie) => movie != null)
          .cast<Movie>()
          .toList();
    });
  }
}


  Future<void> _removeFromFavorites(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteList = prefs.getStringList('favorites') ?? [];
    favoriteList.removeWhere((item) => jsonDecode(item)['id'] == movie.id);
    await prefs.setStringList('favorites', favoriteList);
    setState(() {
      favoriteMovies.removeWhere((m) => m.id == movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Movies')),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('No favorite movies yet.'))
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.voteAverage}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFromFavorites(movie),
                  ),
                );
              },
            ),
    );
  }
}
