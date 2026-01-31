import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:uc_task_2/core/network/api_client.dart';
import 'package:uc_task_2/features/auth/application/auth_notifier.dart';

part 'api_client_provider.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final authAsync = ref.watch(authNotifierProvider);

  Future<String?> getCurrentToken() async {
    return authAsync.valueOrNull?.tokenOrNull;
  }

  return ApiClient(baseUrl: '', getToken: getCurrentToken);
}
