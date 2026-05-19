abstract interface class TokenProvider {
  Future<String?> getAccessToken();
}

/// Placeholder implementation.
/// Replace with secure storage / auth state later.
class InMemoryTokenProvider implements TokenProvider {
  String? _token;

  void setToken(String? token) => _token = token;

  @override
  Future<String?> getAccessToken() async => _token;
}

