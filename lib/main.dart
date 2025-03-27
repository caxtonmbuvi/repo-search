import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:repo_search_app/app.dart';
import 'package:repo_search_app/features/search/ui/repository_search_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  
  runApp(
    const App(
      widget: RepositorySearchScreen(),
    ),
  );
}
