import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:uc_task_2/features/home/domain/movie.dart';
import 'package:uc_task_2/providers/movie_repository_provider.dart';

part 'search_movies_provider.g.dart';

@riverpod
Future<List<Movie>> searchMovies(
  Ref ref,
  String query, {
  CancelToken? cancelToken,
}) async {
  if (query.trim().isEmpty || query.trim().length < 3) {
    return [];
  }

  final repo = ref.watch(movieRepositoryProvider);

  final localCancel = CancelToken();
  ref.onDispose(() => localCancel.cancel());

  if (cancelToken != null) {
    cancelToken.whenCancel.then((_) => localCancel.cancel());
  }

  return repo.searchMovies(query.trim(), cancelToken: localCancel);
}
