import 'dart:convert';

import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUpdatePokemonImageUseCase implements UpdatePokemonImageUseCase {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesUpdatePokemonImageUseCase(this._sharedPreferences);
  @override
  Future<UpdatePokemonImageFailure?> execute(
    Pokemon pokemon,
    String imageUri,
  ) async {
    try {
      final newPokemon = pokemon.copyWith(
        customPictureUrl: imageUri,
      );
      final result = await _sharedPreferences.setString(
        pokemon.name,
        jsonEncode(
          PokemonDto.fromDomain(newPokemon).toJson,
        ),
      );
      if (!result) return UpdatePokemonImageFailure.unknown;
      return null;
    } catch (_) {
      return UpdatePokemonImageFailure.unknown;
    }
  }
}
