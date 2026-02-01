import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uc_task_2/core/constants.dart';

import 'package:uc_task_2/core/network/api_client.dart';
import 'package:uc_task_2/features/auth/application/auth_notifier.dart';

part 'api_client_provider.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  Future<String?> getCurrentToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(
      key: AuthNotifier.tokenKey,
    ); // reuse your constant
  }

  return ApiClient(baseUrl: AppConstants.baseUrl, getToken: getCurrentToken);
}
