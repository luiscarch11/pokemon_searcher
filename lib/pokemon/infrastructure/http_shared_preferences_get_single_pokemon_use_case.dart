import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/save_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';
import 'package:pokemon_searcher/shared/domain/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class HTTPSharedPreferencesGetSinglePokemonUseCase implements GetSinglePokemonUseCase {
  final SavePokemonUseCase _savePokemonUseCase;
  final http.Client _client;
  final SharedPreferences _sharedPreferences;
  HTTPSharedPreferencesGetSinglePokemonUseCase(
    this._savePokemonUseCase,
    this._client,
    this._sharedPreferences,
  );
  @override
  Future<(GetSinglePokemonFailure?, Pokemon?)> execute(String name) async {
    try {
      if (_sharedPreferences.containsKey(name)) {
        final pokemonStr = _sharedPreferences.getString(name)!;
        final pokemonJson = jsonDecode(pokemonStr) as Map<String, dynamic>;
        return (
          null,
          PokemonDto.fromLocalJson(pokemonJson).toDomain,
        );
      }
      final url = StringConstants.getPokemonsWithFilterEndpointUrl(name);
      final response = await _client.get(
        Uri.parse(url),
      );
      if (response.statusCode != 200) {
        return (
          GetSinglePokemonFailure.unknown,
          null,
        );
      }
      final pokemonToReturn = PokemonDto.fromJson(
        jsonDecode(
          response.body,
        ) as Map<String, dynamic>,
      ).toDomain;
      await _savePokemonUseCase.execute(
        pokemonToReturn,
      );
      return (
        null,
        pokemonToReturn,
      );
    } catch (e) {
      return (
        GetSinglePokemonFailure.unknown,
        null,
      );
    }
  }
}
