import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/save_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/http_fetch_pokemons_list_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/shared_preferences_save_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/presentation/shared_preferences_update_pokemon_image_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../pokemon/domain/get_single_pokemon_use_case.dart';
import '../../pokemon/infrastructure/http_shared_preferences_get_single_pokemon_use_case.dart';

class RepositoryManager {
  static Future<Widget> initialize(Widget widget) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final httpClient = http.Client();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SavePokemonUseCase>(
          create: (_) => SharedPreferencesSavePokemonUseCase(
            sharedPrefs,
          ),
        ),
        RepositoryProvider<UpdatePokemonImageUseCase>(
          create: (_) => SharedPreferencesUpdatePokemonImageUseCase(
            sharedPrefs,
          ),
        ),
        RepositoryProvider<GetSinglePokemonUseCase>(
          create: (context) => HTTPSharedPreferencesGetSinglePokemonUseCase(
            context.read<SavePokemonUseCase>(),
            httpClient,
            sharedPrefs,
          ),
        ),
        RepositoryProvider<FetchPokemonsListUseCase>(
          create: (context) => HTTPFetchPokemonsListUseCase(
            httpClient,
            context.read<GetSinglePokemonUseCase>(),
          ),
        ),
      ],
      child: widget,
    );
  }
}
