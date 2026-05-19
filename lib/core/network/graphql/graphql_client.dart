import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../dio_client.dart';

class GraphQLDioClient {
  GraphQLDioClient(
    this._client, {
    this.endpoint = ApiEndpoints.graphQL,
  });

  final DioClient _client;
  final String endpoint;

  Future<Map<String, dynamic>> query({
    required String graphqlQuery,
    Map<String, dynamic>? variables,
    String? operationName,
    Options? options,
  }) async {
    final json = await _client.post<Map<String, dynamic>>(
      endpoint,
      data: <String, dynamic>{
        'query': graphqlQuery,
        if (variables != null) 'variables': variables,
        if (operationName != null) 'operationName': operationName,
      },
      options: options,
    );

    _throwIfGraphQLErrors(json);

    final data = json['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return data.cast<String, dynamic>();
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> mutate({
    required String graphqlQuery,
    Map<String, dynamic>? variables,
    String? operationName,
    Options? options,
  }) =>
      query(
        graphqlQuery: graphqlQuery,
        variables: variables,
        operationName: operationName,
        options: options,
      );

  void _throwIfGraphQLErrors(Map<String, dynamic> json) {
    final errors = json['errors'];
    if (errors is List && errors.isNotEmpty) {
      throw GraphQLResponseException(errors);
    }
  }
}

final class GraphQLResponseException implements Exception {
  const GraphQLResponseException(this.errors);

  final List<dynamic> errors;

  @override
  String toString() => 'GraphQLResponseException(errors: $errors)';
}

