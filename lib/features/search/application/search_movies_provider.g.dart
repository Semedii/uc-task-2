// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMoviesHash() => r'cf318ef3b3ddd91f54b7d597cc1c5c13299d8752';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchMovies].
@ProviderFor(searchMovies)
const searchMoviesProvider = SearchMoviesFamily();

/// See also [searchMovies].
class SearchMoviesFamily extends Family<AsyncValue<List<Movie>>> {
  /// See also [searchMovies].
  const SearchMoviesFamily();

  /// See also [searchMovies].
  SearchMoviesProvider call(String query, {CancelToken? cancelToken}) {
    return SearchMoviesProvider(query, cancelToken: cancelToken);
  }

  @override
  SearchMoviesProvider getProviderOverride(
    covariant SearchMoviesProvider provider,
  ) {
    return call(provider.query, cancelToken: provider.cancelToken);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchMoviesProvider';
}

/// See also [searchMovies].
class SearchMoviesProvider extends AutoDisposeFutureProvider<List<Movie>> {
  /// See also [searchMovies].
  SearchMoviesProvider(String query, {CancelToken? cancelToken})
    : this._internal(
        (ref) => searchMovies(
          ref as SearchMoviesRef,
          query,
          cancelToken: cancelToken,
        ),
        from: searchMoviesProvider,
        name: r'searchMoviesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchMoviesHash,
        dependencies: SearchMoviesFamily._dependencies,
        allTransitiveDependencies:
            SearchMoviesFamily._allTransitiveDependencies,
        query: query,
        cancelToken: cancelToken,
      );

  SearchMoviesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.cancelToken,
  }) : super.internal();

  final String query;
  final CancelToken? cancelToken;

  @override
  Override overrideWith(
    FutureOr<List<Movie>> Function(SearchMoviesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchMoviesProvider._internal(
        (ref) => create(ref as SearchMoviesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Movie>> createElement() {
    return _SearchMoviesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchMoviesProvider &&
        other.query == query &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, cancelToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchMoviesRef on AutoDisposeFutureProviderRef<List<Movie>> {
  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `cancelToken` of this provider.
  CancelToken? get cancelToken;
}

class _SearchMoviesProviderElement
    extends AutoDisposeFutureProviderElement<List<Movie>>
    with SearchMoviesRef {
  _SearchMoviesProviderElement(super.provider);

  @override
  String get query => (origin as SearchMoviesProvider).query;
  @override
  CancelToken? get cancelToken => (origin as SearchMoviesProvider).cancelToken;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
