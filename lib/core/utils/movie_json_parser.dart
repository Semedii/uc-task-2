import 'package:uc_task_2/features/home/domain/movie.dart';

List<Movie> parseMovieList(List<dynamic> jsonList) {
  return jsonList
      .map((json) => Movie.fromJson(json as Map<String, dynamic>))
      .toList();
}
