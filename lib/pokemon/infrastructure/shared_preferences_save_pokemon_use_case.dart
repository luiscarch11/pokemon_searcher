import 'dart:convert';

import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/save_pokemon_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/save_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesSavePokemonUseCase implements SavePokemonUseCase {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesSavePokemonUseCase(this._sharedPreferences);
  @override
  Future<SavePokemonFailure?> execute(Pokemon pokemon) async {
    try {
      final pokemonStr = jsonEncode(
        PokemonDto.fromDomain(pokemon).toJson,
      );
      final result = await _sharedPreferences.setString(
        pokemon.name,
        pokemonStr,
      );
      if (!result) {
        return SavePokemonFailure.unknownError;
      }
      return null;
    } catch (_) {
      return SavePokemonFailure.unknownError;
    }
  }
}
