import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:repo_search_app/utils/api/app_interceptor.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_ENDPOINT'].toString(),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add the interceptor to Dio.
  dio.interceptors.add(
    AppInterceptor(
      dio,
    ),
  );
  // Disable SSL verification for testing (not recommended for production).
  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  return dio;
}
