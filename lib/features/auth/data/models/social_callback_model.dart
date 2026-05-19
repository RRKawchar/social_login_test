

import 'package:social_login_test/features/auth/domain/entities/social_callback_entity.dart';

class SocialCallbackModel extends SocialCallbackEntity {
  const SocialCallbackModel({
    required super.accessToken,
    super.email,
    super.firstName,
    super.lastName,
    required super.orgId,
    required super.organizationName,
    required super.orgSubDomain,
    required super.refreshToken,
    super.sessionId,
    required super.userId,
  });

  factory SocialCallbackModel.fromJson(Map<String, dynamic> json) {
    final data = json['data']['manageAuthenticationCallback'];

    return SocialCallbackModel(
      accessToken: data['access_token'] ?? '',
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      orgId: data['org_id'] ?? '',
      organizationName: data['organization_name'] ?? '',
      orgSubDomain: data['org_sub_domain'] ?? '',
      refreshToken: data['refresh_token'] ?? '',
      sessionId: data['session_id'],
      userId: data['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'org_id': orgId,
      'organization_name': organizationName,
      'org_sub_domain': orgSubDomain,
      'refresh_token': refreshToken,
      'session_id': sessionId,
      'user_id': userId,
    };
  }
}