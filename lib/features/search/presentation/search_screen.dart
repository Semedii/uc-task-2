import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:uc_task_2/core/hooks/use_debounce.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/core/widgets/error_view.dart';
import 'package:uc_task_2/core/widgets/loading_view.dart';
import 'package:uc_task_2/core/widgets/movie_item.dart';
import 'package:uc_task_2/features/movie_details/presentation/movie_details_screen.dart';
import 'package:uc_task_2/features/search/application/search_movies_provider.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchText = useState('');

    final debouncedQuery = useDebounce(
      searchText.value,
      const Duration(milliseconds: 500),
    );

    useEffect(() {
      void listener() {
        final newText = searchController.text.trim();
        if (newText != searchText.value) {
          searchText.value = newText;
        }
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    final searchResults = ref.watch(searchMoviesProvider(debouncedQuery));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Search Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          searchController.clear();
                          searchText.value = '';
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (movies) {
                if (debouncedQuery.isEmpty) {
                  return const Center(
                    child: Text(
                      'Start typing to search',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                if (movies.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies found',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(movieId: movie.id),
                          ),
                        );
                      },
                      child: MovieItem(movie),
                    );
                  },
                );
              },
              loading: () => LoadingView(),
              error: (err, st) => ErrorView(
                message: err.toString(),
                onRetry: () => ref.invalidate(searchMoviesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
