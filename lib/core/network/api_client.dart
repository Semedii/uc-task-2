import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required Future<String?> Function() getToken,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
           },
         ),
       )..interceptors.add(DioInterceptor(getToken: getToken));

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) {
    return _dio.get(path, queryParameters: query, cancelToken: cancelToken);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _dio.post(path, data: body, cancelToken: cancelToken);
  }
}
