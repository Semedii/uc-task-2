import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';

class MovieItem extends HookWidget {
  final Movie movie;
  const MovieItem(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Transform.scale(scale: 0.95 + 0.05 * value, child: child),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoviePoster(movie),
          const SizedBox(height: 8),
          _buildMovieTitle(movie),
        ],
      ),
    );
  }

  ClipRRect _buildMoviePoster(Movie movie) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w185${movie.posterPath ?? ''}',
        width: 140,
        height: 180,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: AppColors.card),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  SizedBox _buildMovieTitle(Movie movie) {
    return SizedBox(
      width: 140,
      child: Text(
        movie.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
