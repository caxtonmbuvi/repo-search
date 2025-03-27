import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_repository.freezed.dart';
part 'github_repository.g.dart';

@freezed
class GithubRepository with _$GithubRepository {
  const factory GithubRepository({
    required String name,
    required Owner owner,
  }) = _GithubRepository;

  factory GithubRepository.fromJson(Map<String, dynamic> json) =>
      _$GithubRepositoryFromJson(json);
}

@freezed
class Owner with _$Owner {
  const factory Owner({
    required String login,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) =>
      _$OwnerFromJson(json);
}