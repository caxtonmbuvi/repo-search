import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/github_repository.dart';

class GithubRepositoryService {
  final Dio dio;

  GithubRepositoryService({required this.dio});

  Future<List<GithubRepository>> fetchUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    final url =
        '/$username/repos?per_page=$perPage&page=$page';

    final response = await dio.get(url);

    log('Response: $response');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch repositories: ${response.statusMessage}');
    }

    final List<dynamic> data = response.data;
    return data.map((json) => GithubRepository.fromJson(json)).toList();
  }
}
