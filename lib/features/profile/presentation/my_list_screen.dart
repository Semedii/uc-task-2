import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:uc_task_2/core/theme/app_colors.dart';

import 'package:hive_flutter/hive_flutter.dart';
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
      body: ValueListenableBuilder<Box<int>>(
        valueListenable: Hive.box<int>('favorites').listenable(),
        builder: (context, box, _) {
          final favoriteIds = box.values.toList();

          if (favoriteIds.isEmpty) {
            return _buildListEmpty();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteIds.length,
            itemBuilder: (context, index) {
              final movieId = favoriteIds[index];
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
                    SnackBar(content: Text('Movie removed from My List')),
                  );
                },
                child: _buildMovieCard(context, movieId, box),
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

  Card _buildMovieCard(BuildContext context, int movieId, Box<int> box) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildLeadingIcon(),
        title: _buildMovieId(movieId),
        subtitle: _buildSubtitle(),
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

  ClipRRect _buildLeadingIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 90,
        color: AppColors.background, // placeholder
        child: const Center(
          child: Icon(Icons.movie, color: AppColors.primary, size: 30),
        ),
      ),
    );
  }

  Text _buildMovieId(int movieId) {
    return Text(
      'Movie ID: $movieId', // ← replace with real title when fetching
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Text _buildSubtitle() {
    return Text(
      'Added to list',
      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    );
  }

  IconButton _buildDeleteIcon(Box<int> box, int movieId) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      onPressed: () => box.delete(movieId),
    );
  }
}
