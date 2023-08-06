import 'package:flutter/material.dart';

import 'package:pokemon_searcher/pokemon/presentation/pokemons_list_page.dart';

import 'shared/presentation/repository_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    await RepositoryManager.initialize(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const PokemonsListPage(),
      ),
    );
  }
}
