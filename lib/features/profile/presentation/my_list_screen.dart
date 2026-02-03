import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/features/movie_details/presentation/movie_details_screen.dart';

class MyListScreen extends StatelessWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My List'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<Box<Map<String, dynamic>>>(
        valueListenable: Hive.box<Map<String, dynamic>>(
          'favorites',
        ).listenable(),
        builder: (context, box, _) {
          final favorites = box.values.toList();

          if (favorites.isEmpty) {
            return _buildListEmpty();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final data = favorites[index];
              final movieId = data['id'] as int;
              return Dismissible(
                key: ValueKey(movieId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  box.delete(movieId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Movie removed from My List')),
                  );
                },
                child: _buildMovieCard(context, data, box),
              );
            },
          );
        },
      ),
    );
  }

  Center _buildListEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 24),
          Text(
            'Your list is empty',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add movies from the details screen',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Card _buildMovieCard(
    BuildContext context,
    Map<String, dynamic> data,
    Box<Map<String, dynamic>> box,
  ) {
    final movieId = data['id'] as int;
    final title = data['title'] as String? ?? 'Unknown Title';
    final posterPath = data['posterPath'] as String?;
    final releaseDate = data['releaseDate'] as String?;

    final year = releaseDate != null && releaseDate.length >= 4
        ? releaseDate.substring(0, 4)
        : '';

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildLeadingPoster(posterPath),
        title: _buildMovieTitle(title),
        subtitle: _buildSubtitle(year),
        trailing: _buildDeleteIcon(box, movieId),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movieId: movieId),
            ),
          );
        },
      ),
    );
  }

  ClipRRect _buildLeadingPoster(String? posterPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 60,
        height: 90,
        child: posterPath != null && posterPath.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w92$posterPath',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.background),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.movie, color: AppColors.primary, size: 30),
                ),
              )
            : Container(
                color: AppColors.background,
                child: const Center(
                  child: Icon(Icons.movie, color: AppColors.primary, size: 30),
                ),
              ),
      ),
    );
  }

  Text _buildMovieTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Text _buildSubtitle(String year) {
    return Text(
      year.isNotEmpty ? 'Released $year' : 'Added to list',
      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    );
  }

  IconButton _buildDeleteIcon(Box<Map<String, dynamic>> box, int movieId) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      onPressed: () => box.delete(movieId),
    );
  }
}
