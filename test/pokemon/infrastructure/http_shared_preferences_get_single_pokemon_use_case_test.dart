import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mocktail/mocktail.dart';

import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';

import 'package:pokemon_searcher/pokemon/domain/save_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/http_shared_preferences_get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';
import 'package:pokemon_searcher/shared/domain/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/pokemon_test.dart';
import 'http_fetch_pokemons_list_use_case_test.dart';

class MockSavePokemonUseCase extends Mock implements SavePokemonUseCase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group(
    'HTTPSharedPreferencesGetSinglePokemonUseCase',
    () {
      late SavePokemonUseCase savePokemonUseCase;
      late http.Client httpClient;
      late SharedPreferences sharedPreferences;
      late HTTPSharedPreferencesGetSinglePokemonUseCase useCase;

      setUp(
        () {
          registerFallbackValue(pokemonDomain);
          registerFallbackValue(
            Uri.parse('https://pokeapi.co/api/v2/pokemon/1/'),
          );
          savePokemonUseCase = MockSavePokemonUseCase();
          httpClient = MockHttpClient();
          sharedPreferences = MockSharedPreferences();
          useCase = HTTPSharedPreferencesGetSinglePokemonUseCase(
            savePokemonUseCase,
            httpClient,
            sharedPreferences,
          );
        },
      );

      test(
        'returns failure if http client throws an exception',
        () async {
          const name = 'bulbasaur';
          when(
            () => sharedPreferences.containsKey(name),
          ).thenReturn(false);
          final url = StringConstants.getPokemonsWithFilterEndpointUrl(name);
          when(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).thenThrow(
            Exception(),
          );

          final result = await useCase.execute(name);

          expect(
            result,
            equals(
              (
                GetSinglePokemonFailure.unknown,
                null,
              ),
            ),
          );
          verifyNever(
            () => savePokemonUseCase.execute(
              any(),
            ),
          );
          verify(
            () => sharedPreferences.containsKey(name),
          ).called(1);
          verify(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).called(1);
        },
      );

      test(
        'returns failure if http response is not successful',
        () async {
          const name = 'bulbasaur';
          when(
            () => sharedPreferences.containsKey(name),
          ).thenReturn(false);
          final url = StringConstants.getPokemonsWithFilterEndpointUrl(name);
          final response = http.Response(
            'Error',
            500,
          );
          when(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).thenAnswer(
            (_) async => response,
          );

          final result = await useCase.execute(name);

          expect(
            result,
            equals(
              (
                GetSinglePokemonFailure.unknown,
                null,
              ),
            ),
          );
          verifyNever(
            () => savePokemonUseCase.execute(
              any(),
            ),
          );
          verify(
            () => sharedPreferences.containsKey(name),
          ).called(1);
          verify(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).called(1);
        },
      );

      test(
        'returns pokemon from shared preferences if it exists',
        () async {
          const name = 'bulbasaur';

          when(
            () => sharedPreferences.containsKey(name),
          ).thenReturn(true);
          when(
            () => sharedPreferences.getString(name),
          ).thenReturn(
            jsonEncode(
              PokemonDto.fromDomain(
                pokemonDomain,
              ).toJson,
            ),
          );

          final result = await useCase.execute(name);

          expect(
            result,
            equals(
              (
                null,
                pokemonDomain,
              ),
            ),
          );
          verifyNever(
            () => savePokemonUseCase.execute(
              any(),
            ),
          );
          verifyNever(
            () => httpClient.get(
              any(),
            ),
          );
          verify(
            () => sharedPreferences.containsKey(name),
          ).called(1);
          verify(
            () => sharedPreferences.getString(name),
          ).called(1);
        },
      );

      test(
        'returns pokemon from http response and saves it to shared preferences if it does not exist',
        () async {
          const name = 'bulbasaur';

          when(
            () => sharedPreferences.containsKey(name),
          ).thenReturn(false);
          final url = StringConstants.getPokemonsWithFilterEndpointUrl(name);
          final pokemonJson = {
            "name": "bulbasaur",
            "id": 1,
            "types": [
              {
                "type": {"name": "grass"}
              },
              {
                "type": {"name": "poison"}
              }
            ],
            "abilities": [
              {
                "ability": {"name": "overgrow"}
              },
              {
                "ability": {"name": "chlorophyll"}
              }
            ],
            "moves": [
              {
                "move": {"name": "razor-wind"}
              },
              {
                "move": {"name": "swords-dance"}
              }
            ]
          };
          final pokemonDomain = PokemonDto.fromJson(pokemonJson).toDomain;
          final response = http.Response(
            jsonEncode(pokemonJson),
            200,
          );
          when(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).thenAnswer(
            (_) async => response,
          );
          when(
            () => savePokemonUseCase.execute(pokemonDomain),
          ).thenAnswer(
            (_) async => null,
          );

          final result = await useCase.execute(name);

          expect(
            result,
            equals(
              (
                null,
                pokemonDomain,
              ),
            ),
          );

          verify(
            () => savePokemonUseCase.execute(pokemonDomain),
          ).called(1);
          verify(
            () => sharedPreferences.containsKey(name),
          ).called(1);
          verify(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).called(1);
        },
      );
    },
  );
}
