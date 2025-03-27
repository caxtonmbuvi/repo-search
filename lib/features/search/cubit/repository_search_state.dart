import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repo_search_app/features/search/models/github_repository.dart';

part 'repository_search_state.freezed.dart';

@freezed
class RepositorySearchState with _$RepositorySearchState {
  const factory RepositorySearchState({
    @Default([]) List<GithubRepository> repositories,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedMax,
  }) = _RepositorySearchState;
}