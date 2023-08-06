import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/http_fetch_pokemons_list_use_case.dart';
import 'package:pokemon_searcher/shared/domain/pagination_result.dart';
import 'package:pokemon_searcher/shared/domain/string_constants.dart';

class MockGetSinglePokemonUseCase extends Mock implements GetSinglePokemonUseCase {}

class MockPokemonListFetcher extends Mock implements PokemonListFetcher {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  const bulbasourPokemon = Pokemon(
    name: 'bulbasaur',
    number: 1,
    types: [
      PokemonType.grass,
      PokemonType.poison,
    ],
    customPictureUrl: null,
    abilities: [
      Ability(
        name: 'overgrow',
      ),
      Ability(
        name: 'chlorophyll',
      ),
    ],
    attacks: [
      Attack(
        name: 'razor-wind',
      ),
      Attack(
        name: 'swords-dance',
      ),
      Attack(
        name: 'cut',
      ),
      Attack(
        name: 'vine-whip',
      ),
    ],
  );
  const charmanderPokemon = Pokemon(
    name: 'charmander',
    number: 4,
    types: [
      PokemonType.fire,
    ],
    customPictureUrl: null,
    abilities: [
      Ability(
        name: 'blaze',
      ),
      Ability(
        name: 'solar-power',
      ),
    ],
    attacks: [
      Attack(
        name: 'mega-punch',
      ),
      Attack(
        name: 'fire-punch',
      ),
      Attack(
        name: 'thunder-punch',
      ),
      Attack(
        name: 'scratch',
      ),
    ],
  );
  const squirtlePokemon = Pokemon(
    name: 'squirtle',
    number: 7,
    types: [
      PokemonType.water,
    ],
    customPictureUrl: null,
    abilities: [
      Ability(
        name: 'torrent',
      ),
      Ability(
        name: 'rain-dish',
      ),
    ],
    attacks: [
      Attack(
        name: 'mega-punch',
      ),
      Attack(
        name: 'ice-punch',
      ),
      Attack(
        name: 'mega-kick',
      ),
      Attack(
        name: 'headbutt',
      ),
    ],
  );
  group(
    'HTTPFetchPokemonsListUseCase',
    () {
      late GetSinglePokemonUseCase getSinglePokemonUseCase;
      late PokemonListFetcher pokemonListFetcher;
      late http.Client httpClient;
      late HTTPFetchPokemonsListUseCase useCase;

      setUp(
        () {
          getSinglePokemonUseCase = MockGetSinglePokemonUseCase();
          pokemonListFetcher = MockPokemonListFetcher();
          httpClient = MockHttpClient();
          useCase = HTTPFetchPokemonsListUseCase(
            httpClient,
            getSinglePokemonUseCase,
            pokemonListFetcher,
          );
        },
      );
      group(
        'execute',
        () {
          test(
            ' returns a list of pokemons when _pokemonsFetcher.execute returns a list of pokemons and _getSinglePokemonUseCase returns all pokemons successfully',
            () async {
              const url = StringConstants.getPokemonsEndpointUrl;
              final pokemonListFetcherResult = PokemonListFetcherResult(
                'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
                [
                  'bulbasaur',
                  'charmander',
                  'squirtle',
                ],
              );

              final paginationResult = PaginationResult(
                [
                  bulbasourPokemon,
                  charmanderPokemon,
                  squirtlePokemon,
                ],
                true,
              );

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (
                  null,
                  pokemonListFetcherResult,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).thenAnswer(
                (_) async => (null, bulbasourPokemon),
              );
              when(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).thenAnswer(
                (_) async => (null, charmanderPokemon),
              );
              when(
                () => getSinglePokemonUseCase.execute('squirtle'),
              ).thenAnswer(
                (_) async => (null, squirtlePokemon),
              );

              final result = await useCase.execute();

              expect(
                result,
                equals(
                  (
                    null,
                    paginationResult,
                  ),
                ),
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('squirtle'),
              ).called(1);
            },
          );

          test(
            ' returns a failure when the pokemon list fetcher fails',
            () async {
              const url = StringConstants.getPokemonsEndpointUrl;
              const failure = FetchPokemonsListFailure.unexpected;

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (failure, null),
              );

              final result = await useCase.execute();

              expect(
                result,
                equals(
                  (failure, null),
                ),
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
            },
          );

          test(
            'execute returns a failure when the get single pokemon use case fails',
            () async {
              const url = StringConstants.getPokemonsEndpointUrl;
              final pokemonListFetcherResult = PokemonListFetcherResult(
                'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
                [
                  'bulbasaur',
                  'charmander',
                  'squirtle',
                ],
              );

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (
                  null,
                  pokemonListFetcherResult,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).thenAnswer(
                (_) async => (
                  null,
                  bulbasourPokemon,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).thenAnswer(
                (_) async => (
                  GetSinglePokemonFailure.unknown,
                  null,
                ),
              );

              final result = await useCase.execute();

              expect(
                result,
                equals(
                  (FetchPokemonsListFailure.errorFetchingIndividualPokemon, null),
                ),
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).called(1);
              verifyNever(
                () => getSinglePokemonUseCase.execute('squirtle'),
              );
            },
          );
        },
      );
      group(
        'fetchNewPage',
        () {
          test(
            ' returns an empty list when there is no next page',
            () async {
              useCase.nextPageUrl = null;

              final result = await useCase.fetchNewPage();

              expect(
                result,
                equals(
                  (
                    null,
                    PaginationResult(
                      <Pokemon>[],
                      false,
                    ),
                  ),
                ),
              );
              verifyNever(
                () => pokemonListFetcher.execute(
                  any(),
                ),
              );
            },
          );

          test(
            'fetchNewPage returns a list of pokemons',
            () async {
              const url = 'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20';
              useCase.nextPageUrl = url;
              final pokemonListFetcherResult = PokemonListFetcherResult(
                null,
                [
                  'bulbasaur',
                  'charmander',
                  'squirtle',
                ],
              );

              final paginationResult = PaginationResult(
                [
                  bulbasourPokemon,
                  charmanderPokemon,
                  squirtlePokemon,
                ],
                false,
              );

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (
                  null,
                  pokemonListFetcherResult,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).thenAnswer(
                (_) async => (
                  null,
                  bulbasourPokemon,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).thenAnswer(
                (_) async => (
                  null,
                  charmanderPokemon,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('squirtle'),
              ).thenAnswer(
                (_) async => (
                  null,
                  squirtlePokemon,
                ),
              );

              final result = await useCase.fetchNewPage();

              expect(
                result,
                equals(
                  (
                    null,
                    paginationResult,
                  ),
                ),
              );
              expect(
                useCase.nextPageUrl,
                isNull,
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('squirtle'),
              ).called(1);
            },
          );

          test(
            'fetchNewPage returns a failure when the pokemon list fetcher fails',
            () async {
              const url = StringConstants.getPokemonsEndpointUrl;
              const failure = FetchPokemonsListFailure.unexpected;
              useCase.nextPageUrl = url;

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (failure, null),
              );

              final result = await useCase.fetchNewPage();

              expect(
                result,
                equals(
                  (failure, null),
                ),
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
            },
          );

          test(
            'fetchNewPage returns a failure when the get single pokemon use case fails',
            () async {
              const url = StringConstants.getPokemonsEndpointUrl;
              useCase.nextPageUrl = url;
              final pokemonListFetcherResult = PokemonListFetcherResult(
                null,
                [
                  'bulbasaur',
                  'charmander',
                  'squirtle',
                ],
              );

              when(
                () => pokemonListFetcher.execute(url),
              ).thenAnswer(
                (_) async => (
                  null,
                  pokemonListFetcherResult,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).thenAnswer(
                (_) async => (
                  null,
                  bulbasourPokemon,
                ),
              );
              when(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).thenAnswer(
                (_) async => (
                  GetSinglePokemonFailure.unknown,
                  null,
                ),
              );

              final result = await useCase.fetchNewPage();

              expect(
                result,
                equals(
                  (FetchPokemonsListFailure.errorFetchingIndividualPokemon, null),
                ),
              );
              expect(
                useCase.nextPageUrl,
                isNull,
              );
              verify(
                () => pokemonListFetcher.execute(url),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('bulbasaur'),
              ).called(1);
              verify(
                () => getSinglePokemonUseCase.execute('charmander'),
              ).called(1);
              verifyNever(
                () => getSinglePokemonUseCase.execute('squirtle'),
              );
            },
          );
        },
      );
    },
  );
  group(
    'PokemonListFetcher',
    () {
      late http.Client httpClient;
      late PokemonListFetcher pokemonListFetcher;

      setUp(
        () {
          httpClient = MockHttpClient();
          pokemonListFetcher = PokemonListFetcher(httpClient);
        },
      );

      test(
        'returns failure if http client throws an exception',
        () async {
          const url = 'https://pokeapi.co/api/v2/pokemon?offset=0&limit=20';
          when(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).thenThrow(Exception());

          final result = await pokemonListFetcher.execute(url);

          expect(
            result,
            equals(
              (FetchPokemonsListFailure.unexpected, null),
            ),
          );
        },
      );

      test(
        'returns failure if http response is not successful',
        () async {
          const url = 'https://pokeapi.co/api/v2/pokemon?offset=0&limit=20';
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

          final result = await pokemonListFetcher.execute(url);

          expect(
            result,
            equals(
              (
                FetchPokemonsListFailure.unexpected,
                null,
              ),
            ),
          );
        },
      );

      test(
        'returns success with next page url and pokemon names if http response is successful',
        () async {
          const url = 'https://pokeapi.co/api/v2/pokemon?offset=0&limit=20';
          final response = http.Response(
            jsonEncode(
              {
                'next': 'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
                'results': [
                  {'name': 'bulbasaur'},
                  {'name': 'charmander'}
                ]
              },
            ),
            200,
          );
          when(
            () => httpClient.get(
              Uri.parse(url),
            ),
          ).thenAnswer(
            (_) async => response,
          );

          final result = await pokemonListFetcher.execute(url);

          expect(
            result,
            equals(
              (
                null,
                PokemonListFetcherResult(
                  'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
                  ['bulbasaur', 'charmander'],
                )
              ),
            ),
          );
        },
      );
    },
  );
  group(
    'PokemonListFetcherResult\n',
    () {
      test(
        'value comparisons should return true if all properties are equal',
        () {
          final result1 = PokemonListFetcherResult(
            'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
            ['bulbasaur', 'charmander'],
          );
          final result2 = PokemonListFetcherResult(
            'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
            ['bulbasaur', 'charmander'],
          );

          expect(
            result1 == result2,
            isTrue,
          );
        },
      );
      test(
        'value comparisons should return false if any property is not equal',
        () {
          final result1 = PokemonListFetcherResult(
            'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
            ['bulbasaur', 'charmander'],
          );
          final result2 = PokemonListFetcherResult(
            'https://pokeapi.co/api/v2/pokemon?offset=20&limit=20',
            ['bulbasaur', 'charmander', 'squirtle'],
          );

          expect(
            result1 == result2,
            isFalse,
          );
        },
      );
    },
  );
}
