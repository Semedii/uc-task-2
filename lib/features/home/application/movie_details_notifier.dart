import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';
import 'package:uc_task_2/providers/movie_repository_provider.dart';

part 'movie_details_notifier.g.dart';

@Riverpod(keepAlive: true)
@riverpod
Future<Movie> movieDetails(Ref ref, int movieId) async {
  final repo = ref.watch(movieRepositoryProvider);
  return repo.getMovieDetails(movieId);
}
