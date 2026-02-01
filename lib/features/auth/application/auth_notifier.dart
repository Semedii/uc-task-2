import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/features/auth/domain/auth_state.dart';
import 'package:uc_task_2/providers/auth_rep_provider.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  static const tokenKey = 'auth_token';

  late final FlutterSecureStorage _storage;

  @override
  Future<AuthState> build() async {
    _storage = const FlutterSecureStorage();
    return _loadInitialState();
  }

  Future<AuthState> _loadInitialState() async {
    try {
      final token = await _storage.read(key: tokenKey);

      if (token != null && token.isNotEmpty) {
        return AuthState.authenticated(token);
      }

      return const AuthState.unauthenticated();
    } catch (e) {
      return AuthState.error('Failed to load auth state');
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();

    try {
      final token = await ref
          .read(authRepositoryProvider)
          .login(username, password);
      await _storage.write(key: tokenKey, value: token);
      state = AsyncData(AuthState.authenticated(token));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      await _storage.delete(key: tokenKey);
      state = AsyncData(const AuthState.unauthenticated());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  String? get currentToken => state.valueOrNull?.tokenOrNull;
}
