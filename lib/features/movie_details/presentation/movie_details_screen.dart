import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uc_task_2/core/constants.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/features/home/application/movie_details_notifier.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';

class MovieDetailsScreen extends HookConsumerWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(movieAsync),
          SliverToBoxAdapter(
            child: movieAsync.when(
              data: (movie) => _buildDetailsContent(movie, context),
              loading: () => const Center(child: CircularProgressIndicator()),
              //TODO: error screen
              error: (err, st) => Center(
                child: Text(
                  'Failed to load details: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildDetailsContent(Movie movie, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildMetadataRow(movie),
          const SizedBox(height: 16),
          Text(
            movie.overview ?? 'No overview available',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildActionButtons(context, movie),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(AsyncValue<Movie> movieAsync) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: movieAsync.when(
          data: (movie) => CachedNetworkImage(
            imageUrl:
                '${AppConstants.imageBaseUrl}${movie.backdropPath ?? movie.posterPath ?? ''}',
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.card),
          ),
          loading: () => Container(color: AppColors.card),
          error: (_, __) => Container(color: AppColors.card),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(Movie movie) {
    final year = movie.releaseDate?.substring(0, 4) ?? 'N/A';
    final rating = movie.voteAverage?.toStringAsFixed(1) ?? 'N/A';
    final runtime = movie.runtime != null ? '${movie.runtime} min' : 'N/A';

    return Row(
      children: [
        Text(year, style: const TextStyle(color: Colors.white70)),
        const SizedBox(width: 16),
        Text('★ $rating', style: const TextStyle(color: Colors.amber)),
        const SizedBox(width: 16),
        Text(runtime, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Movie movie) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildPlayButton(), _buildToMyListButton(context, movie)],
    );
  }

  ElevatedButton _buildPlayButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Todo
      },
      icon: const Icon(Icons.play_arrow),
      label: const Text('Play'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    );
  }

  OutlinedButton _buildToMyListButton(BuildContext context, Movie movie) {
    return OutlinedButton.icon(
      onPressed: () {
        // TODO:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${movie.title} added to My List')),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('My List'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    );
  }
}
