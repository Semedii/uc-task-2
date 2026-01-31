import 'package:dio/dio.dart';
import 'api_exception.dart';

class DioInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  DioInterceptor({required this.getToken});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    throw _mapDioError(err);
  }

  ApiException _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException(message: 'Connection timeout');
    }

    if (error.type == DioExceptionType.badResponse) {
      final data = error.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : 'Something went wrong';
      return ApiException(
        message: message,
        statusCode: error.response?.statusCode,
      );
    }

    if (error.type == DioExceptionType.cancel) {
      return ApiException(message: 'Request cancelled');
    }

    return ApiException(message: 'Network error');
  }
}
