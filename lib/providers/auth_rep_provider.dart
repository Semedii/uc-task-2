import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/features/auth/data/auth_repository.dart';
import 'package:uc_task_2/providers/api_client_provider.dart';

part 'auth_rep_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return AuthRepository(api);
}
