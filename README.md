# Flutter Movie Browsing

Date: February 2026

# What the app does

This is a Flutter app for browsing movies. It has a home screen with category rails,
movie details, a simple video player, search, and a My List for favorites.

# Main features

- Home screen with 5 horizontal rails (Action, Comedy, Drama, Sci-Fi, Horror)
- Each rail has 20+ movies and horizontal scrolling
- Vertical scrolling between rails
- Subtle animations when movie cards appear
- Movie details with Play button and Add to My List
- Video player with play/pause, seek bar, fullscreen
- Search with typing delay (debounce)
- My List (offline favorites with title and poster)
- Bottom navigation (Home, Search, Profile)

# How to set up and run

1. Clone the repo
2. Create a file called `.env` in the root folder
3. Get a free key at https://www.themoviedb.org/settings/api
4. put this in your .env file as API_KEY=your_key_here
5. I used FVM for version control so:
   - Run `fvm install`
   - Run `fvm flutter pub get`
   - Run `fvm flutter run`

# Architecture

I used a clean structre with folders for different parts.

- Core/ shared things like theme, network, hooks, widgets, utils
- features/ each feature separate (home, search, player, profile, movie_details)
- providers/ Riverpod providers that

State management with Riverpod (code-gen, AsyncValue for loading/error/data).
UI with hooks (useState, useEffect, useMemoized, custom useDebounce).
Network with Dio + ApiClient wrapper.
Local storage with Hive (favorites as map with id, title, posterPath, releaseDate).
Reusable widgets like MovieItem, MovieRail, ErrorView, LoadingView.

# Isolate Usage

I used isolates for heavy work so the UI stays smooth.

- Background isolate (with compute):
  - Parsing JSON from TMDb discover and search endpoints
  - Why: These can return 20+ movies, fromJson is heavy → would cause jank if on main thread

- Main isolate:
  - All UI (rendering, scrolling, animations, gestures)
  - Riverpod rebuilds
  - Video player

I only used isolates for discover and search because they have the biggest JSON. Details is small so no need.
This keeps main thread free so no dropped frames during scroll or load.

# Performance Optimizations

- Lazy loading with ListView.builder / GridView.builder (only build visible items)
- CachedNetworkImage for posters (no reloads)
- Debounce in search (500ms) + CancelToken (cancel old requests)
- Isolates for parsing
- Adaptive rail heights (responsive but fixed for good layout performance)
- Reusable components (less rebuilds)
- Lottie for loading (nice animation without jank)

# Unit Tests

Tests for:

- MoviesNotifier (fetch categories, error handling)
- Isolate parsing (valid, empty, invalid JSON)
  run with `flutter test`

## Packages I Used

I used these packages:

- dio: for API calls (good for cancel tokens)
- flutter_hooks + hooks_riverpod: for functional widgets and Riverpod
- riverpod + riverpod_annotation + riverpod_generator: for state management
- freezed + freezed_annotation: for immutable models
- json_annotation + json_serializable: for JSON parsing
- cached_network_image: for fast poster loading
- better_player_plus: for video player (good controls)
- hive + hive_flutter: for offline favorites
- flutter_secure_storage: for token storage
- flutter_dotenv: for API key from .env
- lottie: for loading animations

## CI with GitHub Actions

I added a simple workflow to run tests automatically on every push and created dummy .env file for github actions.

File: `.github/workflows/test.yml`
