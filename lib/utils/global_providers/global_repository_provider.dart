import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repo_search_app/features/search/repo/github_repository_service.dart';
import 'package:repo_search_app/utils/api/api_client.dart';

class GlobalRepositoryProvider extends StatelessWidget {
  const GlobalRepositoryProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => createDio(),
        ),
        RepositoryProvider(
          create: (context) => GithubRepositoryService(dio: context.read()),
        ),
      ],
      child: child,
    );
  }
}
