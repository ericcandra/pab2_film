import 'package:film/models/movie.dart';
import 'package:film/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  bool _isLoading = true;

  Future<void> _loadMovies() async {
    try {
      final List<Map<String, dynamic>> _allMoviesData = await _apiService.getAllMovies();
      final List<Map<String, dynamic>> _trendingMoviesData = await _apiService.getTrendingMovies();
      final List<Map<String, dynamic>> _popularMoviesData = await _apiService.getPopularMovies();
    
      setState(() {
        _allMovies = _allMoviesData.map((e) => Movie.fromJson(e)).toList();
        _trendingMovies = _trendingMoviesData.map((e) => Movie.fromJson(e)).toList();
        _popularMovies = _popularMoviesData.map((e) => Movie.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading movies: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieList('All Movies', _allMovies),
                  _buildMovieList('Trending Movies', _trendingMovies),
                  _buildMovieList('Popular Movies', _popularMovies),
                ],
              ),
            ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final Movie movie = movies[index];
              return GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      movie.posterPath.isNotEmpty
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              height: 150,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 150,
                              width: 100,
                              color: Colors.grey,
                              child: const Icon(Icons.image_not_supported),
                            ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title.length > 14
                            ? '${movie.title.substring(0, 10)}...'
                            : movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
