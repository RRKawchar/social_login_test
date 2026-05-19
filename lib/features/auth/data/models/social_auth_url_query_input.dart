class SocialAuthUrlQueryInput {
  const SocialAuthUrlQueryInput({
    required this.platform,
    required this.path,
    required this.prompt,
    required this.subDomain,
  });

  final String platform;
  final String path;
  final String prompt;
  final String subDomain;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'platform': platform,
        'path': path,
        'prompt': prompt,
        'sub_domain': subDomain,
      };
}
