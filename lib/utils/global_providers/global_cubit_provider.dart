import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repo_search_app/features/search/cubit/repository_search_cubit.dart';

class GlobalCubitProvider extends StatelessWidget {
  const GlobalCubitProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RepositorySearchCubit(repositoryService: context.read()),
        ),
      ],
      child: child,
    );
  }
}
