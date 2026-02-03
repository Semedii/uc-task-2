import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/core/widgets/error_view.dart';
import 'package:uc_task_2/core/widgets/loading_view.dart';
import 'package:uc_task_2/features/home/application/movies_notifier.dart';
import 'package:uc_task_2/features/home/presentation/widgets/movie_rail.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: moviesAsync.when(
        data: (categoryMap) => ListView.builder(
          itemCount: categoryMap.length,
          itemBuilder: (context, index) {
            final genreId = categoryMap.keys.elementAt(index);
            final movies = categoryMap[genreId]!;
            return MovieRail(categoryId: genreId, movies: movies);
          },
        ),
        loading: () => LoadingView(),
        error: (err, stack) => ErrorView(
          message: 'Failed to load movies: $err',
          onRetry: () => ref.invalidate(moviesNotifierProvider),
        ),
      ),
    );
  }
}
