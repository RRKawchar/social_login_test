import 'package:dio/dio.dart';

import '../errors/network_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      err.copyWith(error: NetworkException.fromDio(err)),
    );
  }
}

