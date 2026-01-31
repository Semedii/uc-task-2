import 'package:uc_task_2/core/network/api_client.dart';
import 'package:uc_task_2/core/network/api_exception.dart';

class AuthRepository {
  final ApiClient _api;

  AuthRepository(this._api);

  Future<String> login(String email, String password) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      final token = response.data?['token'] as String?;
      if (token == null || token.isEmpty) {
        throw ApiException(message: 'No token received from server');
      }

      return token;
    } on ApiException catch (e) {
      throw ApiException(message: e.toString());
    } catch (e) {
      throw ApiException(message: 'Unexpected error during login: $e');
    }
  }

  Future<bool> isTokenValid(String token) async {
    //TODO check token validty with jwt decoder later on
    return true;
  }
}
