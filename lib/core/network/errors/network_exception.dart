import 'package:dio/dio.dart';

sealed class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  static NetworkException fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutNetworkException('Request timed out');
      case DioExceptionType.badCertificate:
        return const BadCertificateNetworkException('Bad TLS certificate');
      case DioExceptionType.connectionError:
        return const ConnectionNetworkException('No internet connection');
      case DioExceptionType.cancel:
        return const CancelledNetworkException('Request cancelled');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        return HttpNetworkException(
          statusCode: status,
          message: 'Request failed${status == null ? '' : ' ($status)'}',
        );
      case DioExceptionType.unknown:
        return UnknownNetworkException(e.message ?? 'Unknown network error');
    }
  }

  @override
  String toString() => '$runtimeType(message: $message)';
}

final class TimeoutNetworkException extends NetworkException {
  const TimeoutNetworkException(super.message);
}

final class ConnectionNetworkException extends NetworkException {
  const ConnectionNetworkException(super.message);
}

final class CancelledNetworkException extends NetworkException {
  const CancelledNetworkException(super.message);
}

final class BadCertificateNetworkException extends NetworkException {
  const BadCertificateNetworkException(super.message);
}

final class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException(super.message);
}

final class HttpNetworkException extends NetworkException {
  const HttpNetworkException({
    required this.statusCode,
    required String message,
  }) : super(message);

  final int? statusCode;
}

