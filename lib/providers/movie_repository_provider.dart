import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/features/home/data/movie_repository.dart';
import 'package:uc_task_2/providers/api_client_provider.dart';

part 'movie_repository_provider.g.dart';

@riverpod
MovieRepository movieRepository(Ref ref) {
  return MovieRepository(ref.watch(apiClientProvider));
}
