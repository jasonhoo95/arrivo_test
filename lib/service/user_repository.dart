import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// import 'package:infogames/repository/models/model_barrel.dart';
// import 'package:infogames/repository/models/result_error.dart';
import '/models/models.dart';

class UserRepository {
  UserRepository({
    http.Client? httpClient,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Client _httpClient;

  Uri getUrl({
    required String url,
    Map<String, String>? extraParameters,
  }) {
    final queryParameters = <String, String>{};
    if (extraParameters != null) {
      queryParameters.addAll(extraParameters);
    }

    return Uri.parse('$baseUrl/$url').replace(
      queryParameters: queryParameters,
    );
  }

  Future<List<User>> getUser(int page, String users) async {
    final response = await _httpClient.get(
      getUrl(url: 'posts', extraParameters: {
        '_page': page.toString(),
        'q': users,
        '_limit': '5'
      }),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      print(result);
      print('results');
      if (result.length > 0) {
        return result.map<User>((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load album');
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<User>> searchUser(String genre) async {
    final response = await _httpClient.get(
      getUrl(url: 'posts', extraParameters: {'q': genre, '_limit': '5'}),
    );
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      print(result);
      print('results');

      return result.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
