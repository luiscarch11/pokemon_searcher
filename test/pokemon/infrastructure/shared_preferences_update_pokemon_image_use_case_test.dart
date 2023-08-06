import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';

import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';

import 'package:pokemon_searcher/pokemon/presentation/shared_preferences_update_pokemon_image_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_shared_preferences_get_single_pokemon_use_case_test.dart';

void main() {
  group(
    'SharedPreferencesUpdatePokemonImageUseCase',
    () {
      late SharedPreferences sharedPreferences;
      late SharedPreferencesUpdatePokemonImageUseCase useCase;
      const pokemon = Pokemon(
        name: 'bulbasaur',
        number: 1,
        types: [
          PokemonType.grass,
          PokemonType.poison,
        ],
        customPictureUrl: null,
        abilities: [
          Ability(name: 'overgrow'),
          Ability(name: 'chlorophyll'),
        ],
        attacks: [
          Attack(name: 'razor-wind'),
          Attack(name: 'swords-dance'),
          Attack(name: 'cut'),
          Attack(name: 'vine-whip'),
        ],
      );
      const imageUri = 'https://example.com/image.png';
      final newPokemonStr = jsonEncode(
        PokemonDto.fromDomain(
          pokemon.copyWith(
            customPictureUrl: imageUri,
          ),
        ).toJson,
      );
      setUp(
        () {
          sharedPreferences = MockSharedPreferences();
          useCase = SharedPreferencesUpdatePokemonImageUseCase(sharedPreferences);
        },
      );

      test(
        'returns failure if shared preferences throws an exception',
        () async {
          when(
            () => sharedPreferences.setString(
              any(),
              any(),
            ),
          ).thenThrow(
            Exception(),
          );

          final result = await useCase.execute(
            pokemon,
            imageUri,
          );

          expect(
            result,
            equals(
              UpdatePokemonImageFailure.unknown,
            ),
          );
          verify(
            () => sharedPreferences.setString(
              pokemon.name,
              newPokemonStr,
            ),
          ).called(1);
        },
      );

      test(
        'returns failure if shared preferences returns false',
        () async {
          when(
            () => sharedPreferences.setString(
              any(),
              any(),
            ),
          ).thenAnswer(
            (_) async => false,
          );

          final result = await useCase.execute(
            pokemon,
            imageUri,
          );

          expect(
            result,
            equals(
              UpdatePokemonImageFailure.unknown,
            ),
          );
          verify(
            () => sharedPreferences.setString(
              pokemon.name,
              newPokemonStr,
            ),
          ).called(1);
        },
      );

      test(
        'updates the pokemon image url in shared preferences',
        () async {
          when(
            () => sharedPreferences.setString(
              any(),
              any(),
            ),
          ).thenAnswer(
            (_) async => true,
          );

          final result = await useCase.execute(
            pokemon,
            imageUri,
          );

          expect(
            result,
            isNull,
          );
          verify(
            () => sharedPreferences.setString(
              pokemon.name,
              newPokemonStr,
            ),
          );
        },
      );
    },
  );
}
