class SocialCallbackEntity {
  final String accessToken;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String orgId;
  final String organizationName;
  final String orgSubDomain;
  final String refreshToken;
  final String? sessionId;
  final String userId;

  const SocialCallbackEntity({
    required this.accessToken,
    this.email,
    this.firstName,
    this.lastName,
    required this.orgId,
    required this.organizationName,
    required this.orgSubDomain,
    required this.refreshToken,
    this.sessionId,
    required this.userId,
  });
}