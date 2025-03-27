import 'package:flutter/material.dart';
import 'package:repo_search_app/utils/global_providers/global_providers.dart';

final routeObserver = RouteObserver<PageRoute<dynamic>>();

class App extends StatelessWidget {
  const App({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return GlobalProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: widget,
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
