import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';
import 'package:uc_task_2/providers/movie_repository_provider.dart';

part 'movies_notifier.g.dart';

@riverpod
class MoviesNotifier extends _$MoviesNotifier {
  @override
  Future<Map<int, List<Movie>>> build() async {
    // Categories: Action=28, Comedy=35, Drama=18, Sci-Fi=878, Horror=27
    final categories = [28, 35, 18, 878, 27];

    final results = <int, List<Movie>>{};
    for (final genre in categories) {
      results[genre] = await ref
          .read(movieRepositoryProvider)
          .getMoviesByGenre(genre);
    }
    return results;
  }
}
