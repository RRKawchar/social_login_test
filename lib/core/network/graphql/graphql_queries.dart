class GraphqlQueries {
  static String getSocialUrl = '''
     query GET_SOCIAL_AUTHENTICATION_URL(\$queryData: SocialAuthenticationURLInputType!) {
   getSocialAuthenticationURL(queryData: \$queryData)
  }
  ''';

  static String manageSocialUrl = '''
     mutation MANAGE_AUTHENTICATION_CALLBACK(\$inputData: SocialAuthenticationInput) {
  manageAuthenticationCallback(inputData: \$inputData) {
    ... on SocialAuthTokensType {
      access_token
      email
      first_name
      last_name
      org_id
      organization_name
      org_sub_domain
      refresh_token
      session_id
      user_id
      __typename
    }
    __typename
  }
}
  ''';
}
