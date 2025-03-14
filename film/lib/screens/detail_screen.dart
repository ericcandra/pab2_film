import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:film/models/movie.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteMovies = prefs.getStringList('favorites');
    if (favoriteMovies != null) {
      setState(() {
        isFavorite = favoriteMovies.contains(widget.movie.id.toString());
      });
    }
  }

  Future<void> _toggleFavorite() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteMovies = prefs.getStringList('favorites') ?? [];

  String movieJson = jsonEncode(widget.movie.toString());
  if (isFavorite) {
    favoriteMovies.remove(movieJson);
  } else {
    favoriteMovies.add(movieJson);
  }

  await prefs.setStringList('favorites', favoriteMovies);
  setState(() {
    isFavorite = !isFavorite;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text('Overview:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(widget.movie.overview, textAlign: TextAlign.justify),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Text('Release Date:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(widget.movie.releaseDate)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 10),
                  const Text('Rating:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(widget.movie.voteAverage.toString())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}