import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uc_task_2/core/widgets/movie_item.dart';
import 'package:uc_task_2/features/home/domain/movie.dart';
import 'package:uc_task_2/features/movie_details/presentation/movie_details_screen.dart';

class MovieRail extends HookWidget {
  final int categoryId;
  final List<Movie> movies;

  const MovieRail({super.key, required this.categoryId, required this.movies});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            _getCategoryName(categoryId),
            style: TextTheme.of(context).titleLarge,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie.id),
                      ),
                    );
                    debugPrint('Tapped ${movie.title}');
                  },
                  child: MovieItem(movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getCategoryName(int id) {
    const map = {
      28: 'Action',
      35: 'Comedy',
      18: 'Drama',
      878: 'Science Fiction',
      27: 'Horror',
    };
    return map[id] ?? 'Unknown';
  }
}
