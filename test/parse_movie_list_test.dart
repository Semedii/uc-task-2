import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uc_task_2/core/utils/movie_json_parser.dart';

void main() {
  group('parseMovieList', () {
    test('parses valid JSON list to Movie objects', () async {
      final jsonList = [
        {'id': 123, 'title': 'Inception', 'poster_path': '/path.jpg'},
        {'id': 456, 'title': 'Matrix'},
      ];

      final movies = await compute(parseMovieList, jsonList);

      expect(movies.length, 2);
      expect(movies[0].id, 123);
      expect(movies[0].title, 'Inception');
      expect(movies[1].id, 456);
      expect(movies[1].title, 'Matrix');
    });

    test('handles empty list', () async {
      final movies = await compute(parseMovieList, <dynamic>[]);
      expect(movies, isEmpty);
    });
  });
}
