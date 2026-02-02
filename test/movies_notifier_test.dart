import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:uc_task_2/features/home/application/movies_notifier.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';
import 'package:uc_task_2/providers/movie_repository_provider.dart';

import 'mocks/movie_repository_mocks.mocks.dart';

void main() {
  group('MoviesNotifier (home movies provider)', () {
    late ProviderContainer container;
    late MockMovieRepository mockRepo;

    setUp(() {
      mockRepo = MockMovieRepository();

      container = ProviderContainer(
        overrides: [movieRepositoryProvider.overrideWithValue(mockRepo)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetches movies for all 5 categories and returns map', () async {
      when(
        mockRepo.getMoviesByGenre(28),
      ).thenAnswer((_) async => [Movie(id: 1, title: 'Action Test')]);
      when(
        mockRepo.getMoviesByGenre(35),
      ).thenAnswer((_) async => [Movie(id: 2, title: 'Comedy Test')]);
      when(
        mockRepo.getMoviesByGenre(18),
      ).thenAnswer((_) async => [Movie(id: 3, title: 'Drama Test')]);
      when(
        mockRepo.getMoviesByGenre(878),
      ).thenAnswer((_) async => [Movie(id: 4, title: 'Sci-Fi Test')]);
      when(
        mockRepo.getMoviesByGenre(27),
      ).thenAnswer((_) async => [Movie(id: 5, title: 'Horror Test')]);

      final result = await container.read(moviesNotifierProvider.future);

      expect(result.length, 5);
      expect(result.keys.toSet(), {28, 35, 18, 878, 27});

      expect(result[28]?.first.title, 'Action Test');
      expect(result[35]?.first.title, 'Comedy Test');

      verify(mockRepo.getMoviesByGenre(28)).called(1);
      verify(mockRepo.getMoviesByGenre(35)).called(1);
      verify(mockRepo.getMoviesByGenre(18)).called(1);
      verify(mockRepo.getMoviesByGenre(878)).called(1);
      verify(mockRepo.getMoviesByGenre(27)).called(1);
    });
  });
}
