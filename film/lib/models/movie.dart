import 'package:flutter/foundation.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final String voteAverage;

  Movie(
      {required this.id, 
      required this.title, 
      required this.overview,
      required this.posterPath, 
      required this.backdropPath, 
      required this.releaseDate, 
      required this.voteAverage});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(id: json['id'], title: json['title'], overview: json['overview'], posterPath: json['poster_Path'], backdropPath: json['backdrop_Path'], releaseDate: json['release_Date'], voteAverage: json['vote_Average'].toDouble());
  }      
}