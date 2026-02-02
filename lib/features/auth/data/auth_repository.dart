import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uc_task_2/core/constants.dart';
import 'package:uc_task_2/core/network/api_client.dart';
import 'package:uc_task_2/core/network/api_exception.dart';

class AuthRepository {
  final ApiClient api;

  AuthRepository(this.api);

  Future<String> login(String email, String password) async {
    try {
      final apiKey = dotenv.env['API_KEY'];
      //normally we would make the login call in here then catch any errors in the catch block
      if (apiKey == null || apiKey.isEmpty) {
        throw ApiException(message: 'No token received from server');
      }
      if (email == AppConstants.username && password == AppConstants.password) {
        return apiKey;
      } else {
        throw ApiException(message: 'invalid credentials');
      }
    } on ApiException catch (e) {
      throw ApiException(message: e.toString());
    } catch (e) {
      throw ApiException(message: 'Unexpected error during login: $e');
    }
  }
}
