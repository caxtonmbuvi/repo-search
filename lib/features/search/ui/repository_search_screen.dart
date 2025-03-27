import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/repository_search_cubit.dart';
import '../cubit/repository_search_state.dart';

class RepositorySearchScreen extends StatefulWidget {
  const RepositorySearchScreen({super.key});

  @override
  RepositorySearchScreenState createState() => RepositorySearchScreenState();
}

class RepositorySearchScreenState extends State<RepositorySearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final username = _controller.text;
    context.read<RepositorySearchCubit>().searchRepositories(username, page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Repository Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter GitHub username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<RepositorySearchCubit, RepositorySearchState>(
              builder: (context, state) {
                if (state.isLoading && state.repositories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null && state.repositories.isEmpty) {
                  return Center(child: Text(state.errorMessage!));
                }
                if (state.repositories.isEmpty) {
                  return const Center(child: Text("No repositories found"));
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification &&
                        scrollNotification.metrics.extentAfter == 0 &&
                        !state.isLoading &&
                        !state.hasReachedMax) {
                      context.read<RepositorySearchCubit>().searchRepositories(
                          _controller.text, page: state.currentPage + 1);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: state.repositories.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.repositories.length) {
                        final repo = state.repositories[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(repo.owner.avatarUrl),
                          ),
                          title: Text(repo.name),
                          subtitle: Text(repo.owner.login),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
