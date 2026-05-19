abstract interface class TokenProvider {
  Future<String?> getAccessToken();

  Future<void> setAccessToken(String? token);
}

/// Placeholder implementation.
/// Replace with secure storage / auth state later.
class InMemoryTokenProvider implements TokenProvider {
  String? _token;

  @override
  Future<void> setAccessToken(String? token) async {
    _token = token;
  }

  @override
  Future<String?> getAccessToken() async => _token;
}

