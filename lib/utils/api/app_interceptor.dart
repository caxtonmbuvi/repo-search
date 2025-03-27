import 'dart:developer';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  AppInterceptor(
    this.dio,
  );

  final Dio dio;

  // Flag to prevent multiple simultaneous refreshes.
  bool _isRefreshing = false;
  // Queue to hold pending requests during token refresh.
  final List<Future<void> Function(String)> _refreshQueue = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('Request: ${options.method} ${options.path}');

    try {
      handler.next(options);
    } catch (e) {
      log('Error in onRequest: $e');
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Request Interception Failed',
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;

      if (_isRefreshing) {
        // Queue the request if a refresh is already in progress.
        _refreshQueue.add((newToken) async {
          options.queryParameters['token'] = newToken;
          try {
            final response = await dio.fetch<Map<String, dynamic>>(options);
            handler.resolve(response);
          } catch (e) {
            handler.next(err);
          }
        });
        return;
      }

      _isRefreshing = true;
      try {
        final response = await dio.fetch<List<dynamic>>(options);
        handler.resolve(response);
      } catch (e) {
        log('Token refresh failed: $e');
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }
}
