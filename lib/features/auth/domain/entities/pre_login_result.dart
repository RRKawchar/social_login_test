class PreLoginResult {
  const PreLoginResult({
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  final String accessToken;
  final String refreshToken;
  final String message;
}
