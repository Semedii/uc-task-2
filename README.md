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

<img width="1290" height="2796" alt="1" src="https://github.com/user-attachments/assets/20050f36-d1fb-4c0d-83f6-0f2c44b14003" />
<img width="1290" height="2796" alt="2" src="https://github.com/user-attachments/assets/46661c24-6286-4592-850b-f99acd1e768d" />
<img width="1290" height="2796" alt="3" src="https://github.com/user-attachments/assets/e9969b34-e493-4af8-be14-63da333236de" />
<img width="1290" height="2796" alt="4" src="https://github.com/user-attachments/assets/9296a8cc-1737-4b1b-9582-ce0b0b025d0a" />
<img width="1290" height="2796" alt="5" src="https://github.com/user-attachments/assets/0fce7afc-e823-4f14-af59-45c157d5208c" />
<img width="1290" height="2796" alt="6" src="https://github.com/user-attachments/assets/b1a2c7d6-ea6a-4745-8ffb-179c1c5e3ca5" />
<img width="1290" height="2796" alt="7" src="https://github.com/user-attachments/assets/266e7cf3-f74a-4266-bcd8-ed2908d54a33" />
<img width="1290" height="2796" alt="8" src="https://github.com/user-attachments/assets/165271a3-cc29-43b2-837c-de8c36e75581" />
<img width="1290" height="2796" alt="9" src="https://github.com/user-attachments/assets/4f164d6c-7701-41e3-b08b-337b3f995806" />


