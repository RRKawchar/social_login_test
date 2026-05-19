import '../../domain/entities/social_auth_url.dart';

class SocialAuthUrlResponseModel {
  const SocialAuthUrlResponseModel({required this.url});

  final String url;

  factory SocialAuthUrlResponseModel.fromGraphQLData(
    Map<String, dynamic> data,
  ) {
    return SocialAuthUrlResponseModel(
      url: data['getSocialAuthenticationURL'] as String? ?? '',
    );
  }

  SocialAuthUrl toEntity() => SocialAuthUrl(url: url);
}
