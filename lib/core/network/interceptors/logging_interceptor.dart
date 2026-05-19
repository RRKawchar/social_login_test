import 'package:dio/dio.dart';

import '../../helper/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.maxBodyChars = 3000});

  final int maxBodyChars;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.info('--> ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      Log.debug('Headers: ${options.headers}');
    }
    if (options.queryParameters.isNotEmpty) {
      Log.debug('Query: ${options.queryParameters}');
    }
    if (options.data != null) {
      Log.debug('Body: ${_truncate(options.data)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.info('<-- ${response.statusCode} ${response.requestOptions.uri}');
    Log.debug('Response: ${_truncate(response.data)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.error(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri} ${err.type}',
    );
    if (err.response?.data != null) {
      Log.debug('Error body: ${_truncate(err.response?.data)}');
    }
    handler.next(err);
  }

  String _truncate(Object? value) {
    final s = value.toString();
    if (s.length <= maxBodyChars) return s;
    return '${s.substring(0, maxBodyChars)}…(${s.length} chars)';
  }
}

