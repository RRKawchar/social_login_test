import '../../domain/entities/pre_login_result.dart';

class PreLoginResponseModel {
  const PreLoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  final String accessToken;
  final String refreshToken;
  final String message;

  factory PreLoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return PreLoginResponseModel(
      accessToken: data['access_token'] as String? ?? '',
      refreshToken: data['refresh_token'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  PreLoginResult toEntity() => PreLoginResult(
        accessToken: accessToken,
        refreshToken: refreshToken,
        message: message,
      );
}
