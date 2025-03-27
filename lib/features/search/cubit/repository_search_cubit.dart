import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:repo_search_app/features/search/repo/github_repository_service.dart';
import 'repository_search_state.dart';

class RepositorySearchCubit extends Cubit<RepositorySearchState> {
  final GithubRepositoryService repositoryService;

  RepositorySearchCubit({required this.repositoryService})
      : super(const RepositorySearchState());

  Future<void> searchRepositories(String username,
      {int page = 1, int perPage = 10}) async {
    if (username.isEmpty) return;

    try {
      // Emit loading state; clear repositories if this is a new search (first page)
      if (page == 1) {
        emit(state.copyWith(
          isLoading: true,
          errorMessage: null,
          repositories: [],
        ));
      } else {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }

      final repos = await repositoryService.fetchUserRepositories(
        username,
        page: page,
        perPage: perPage,
      );

      log('Res: $repos');

      final allRepos = page == 1 ? repos : [...state.repositories, ...repos];
      final reachedMax = repos.length < perPage;

      emit(state.copyWith(
        repositories: allRepos,
        isLoading: false,
        currentPage: page,
        hasReachedMax: reachedMax,
      ));
    } catch (e) {
      log('Error: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
