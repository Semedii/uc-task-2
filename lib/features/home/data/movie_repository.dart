import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uc_task_2/core/network/api_client.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';

class MovieRepository {
  final ApiClient _api;

  MovieRepository(this._api);

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/discover/movie',
      query: {'with_genres': genreId, 'page': page},
    );

    final results = response.data?['results'] as List<dynamic>? ?? [];
    //Since movies data is large and mapping to json is heavy we using isolates in here.
    return compute(_parseMovieList, results);
  }

  static List<Movie> _parseMovieList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await _api.get<Map<String, dynamic>>('/movie/$movieId');
    return Movie.fromJson(response.data!);
  }

  Future<List<Movie>> searchMovies(
    String query, {
    CancelToken? cancelToken,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      '/search/movie',
      query: {'query': query, 'page': 1},
      cancelToken: cancelToken,
    );

    final results = response.data?['results'] as List<dynamic>? ?? [];

    return results
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
