import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon_searcher/pokemon/application/pokemons_list_cubit.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';

import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';
import 'package:pokemon_searcher/shared/domain/pagination_result.dart';

import '../domain/pokemon_test.dart';

class MockFetchPokemonsListUseCase extends Mock implements FetchPokemonsListUseCase {}

class MockGetSinglePokemonUseCase extends Mock implements GetSinglePokemonUseCase {}

void main() {
  group('PokemonsListCubit', () {
    late FetchPokemonsListUseCase fetchPokemonsListUseCase;
    late GetSinglePokemonUseCase getSinglePokemonUseCase;

    setUp(
      () {
        fetchPokemonsListUseCase = MockFetchPokemonsListUseCase();
        getSinglePokemonUseCase = MockGetSinglePokemonUseCase();
      },
    );

    test(
      'initial state is PokemonsListInitial',
      () {
        expect(
          PokemonsListCubit(
            fetchPokemonsListUseCase,
            getSinglePokemonUseCase,
          ).state,
          equals(
            PokemonsListInitial(),
          ),
        );
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits [isLoading: true,] then [isLoading: false, fetchedPokemonsOrFailure: (null, PaginationResult<Pokemon>)] when requestedFirstTime is called and succeeds, with name filter empty',
      setUp: () => when(
        () => fetchPokemonsListUseCase.execute(),
      ).thenAnswer(
        (_) async => (
          null,
          PaginationResult<Pokemon>(
            [
              pokemonDomain,
              pokemonDomain,
            ],
            false,
          ),
        ),
      ),
      build: () {
        return PokemonsListCubit(
          fetchPokemonsListUseCase,
          getSinglePokemonUseCase,
        );
      },
      act: (cubit) => cubit.requestedFirstTime(),
      expect: () => [
        PokemonsListInitial().copyWith(
          isLoading: true,
        ),
        PokemonsListInitial().copyWith(
          isLoading: false,
          fetchedPokemonsOrFailure: (
            null,
            PaginationResult<Pokemon>(
              [
                pokemonDomain,
                pokemonDomain,
              ],
              false,
            ),
          ),
          fetchedPokemons: [
            pokemonDomain,
            pokemonDomain,
          ],
        ),
      ],
      verify: (_) {
        verify(
          () => fetchPokemonsListUseCase.execute(),
        ).called(1);
        verifyNever(
          () => getSinglePokemonUseCase.execute(
            any(),
          ),
        );
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits [isLoading: true, fetchedPokemons: []] then [isLoading: false, fetchedPokemonsOrFailure: (FetchPokemonsListFailure, null)] when requestedFirstTime is called and fails with name filter empty',
      setUp: () => when(
        () => fetchPokemonsListUseCase.execute(),
      ).thenAnswer(
        (_) async => (
          FetchPokemonsListFailure.unexpected,
          null,
        ),
      ),
      build: () {
        return PokemonsListCubit(
          fetchPokemonsListUseCase,
          getSinglePokemonUseCase,
        );
      },
      act: (cubit) => cubit.requestedFirstTime(),
      expect: () => [
        PokemonsListInitial().copyWith(
          isLoading: true,
        ),
        PokemonsListInitial().copyWith(
          isLoading: false,
          fetchedPokemonsOrFailure: (
            FetchPokemonsListFailure.unexpected,
            null,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => fetchPokemonsListUseCase.execute(),
        ).called(1);
        verifyNever(
          () => getSinglePokemonUseCase.execute(
            any(),
          ),
        );
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits [isLoading: true, fetchedPokemons: []] then [isLoading: false, fetchedSinglePokemonOrFailure: (null, Pokemon), fetchedPokemons: [pokemonDomain]] when requestedFirstTime is called with a name filter and succeeds',
      setUp: () => when(
        () => getSinglePokemonUseCase.execute(
          any(),
        ),
      ).thenAnswer(
        (_) async => (
          null,
          pokemonDomain,
        ),
      ),
      build: () {
        return PokemonsListCubit(
          fetchPokemonsListUseCase,
          getSinglePokemonUseCase,
        );
      },
      seed: () => PokemonsListInitial().copyWith(
        nameFilter: 'bulbasaur',
        fetchedPokemons: [
          pokemonDomain,
        ],
      ),
      act: (cubit) {
        return cubit.requestedFirstTime();
      },
      expect: () => [
        PokemonsListInitial().copyWith(
          isLoading: true,
          nameFilter: 'bulbasaur',
          fetchedPokemons: [],
        ),
        PokemonsListInitial().copyWith(
          isLoading: false,
          nameFilter: 'bulbasaur',
          fetchedSinglePokemonOrFailure: (
            null,
            pokemonDomain,
          ),
          fetchedPokemons: [
            pokemonDomain,
          ],
        ),
      ],
      verify: (_) {
        verify(
          () => getSinglePokemonUseCase.execute('bulbasaur'),
        ).called(1);
        verifyNever(
          () => fetchPokemonsListUseCase.execute(),
        );
      },
    );
    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits [isLoading: true, fetchedPokemons: []] then [isLoading: false, fetchedSinglePokemonOrFailure: (Failure, null), fetchedPokemons:previously fetched pokemons] when requestedFirstTime is called with a name filter and fails',
      setUp: () => when(
        () => getSinglePokemonUseCase.execute(
          any(),
        ),
      ).thenAnswer(
        (_) async => (
          GetSinglePokemonFailure.unknown,
          null,
        ),
      ),
      build: () {
        return PokemonsListCubit(
          fetchPokemonsListUseCase,
          getSinglePokemonUseCase,
        );
      },
      seed: () => PokemonsListInitial().copyWith(
        nameFilter: 'bulbasaur',
        fetchedPokemons: [
          pokemonDomain,
          pokemonDomain,
          pokemonDomain,
        ],
      ),
      act: (cubit) {
        return cubit.requestedFirstTime();
      },
      expect: () => [
        PokemonsListInitial().copyWith(
          isLoading: true,
          nameFilter: 'bulbasaur',
          fetchedPokemons: [],
        ),
        PokemonsListInitial().copyWith(
          isLoading: false,
          nameFilter: 'bulbasaur',
          fetchedSinglePokemonOrFailure: (
            GetSinglePokemonFailure.unknown,
            null,
          ),
          fetchedPokemons: [
            pokemonDomain,
            pokemonDomain,
            pokemonDomain,
          ],
        ),
      ],
      verify: (_) {
        verify(
          () => getSinglePokemonUseCase.execute('bulbasaur'),
        ).called(1);
        verifyNever(
          () => fetchPokemonsListUseCase.execute(),
        );
      },
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits received pokemon replacing already-emitted pokemon when changedPokemon is called with a Pokemon whose name is already in the list',
      build: () => PokemonsListCubit(fetchPokemonsListUseCase, getSinglePokemonUseCase),
      seed: () => PokemonsListInitial().copyWith(
        fetchedPokemons: [
          pokemonDomain,
          pokemonDomain.copyWith(name: 'anyName'),
          pokemonDomain.copyWith(name: 'anyOtherName'),
        ],
      ),
      act: (cubit) {
        cubit.changedPokemon(
          pokemonDomain.copyWith(
            name: 'anyName',
            types: [
              PokemonType.bug,
              PokemonType.fighting,
            ],
          ),
        );
      },
      expect: () => [
        PokemonsListInitial().copyWith(
          fetchedPokemons: [
            pokemonDomain,
            pokemonDomain.copyWith(
              name: 'anyName',
              types: [
                PokemonType.bug,
                PokemonType.fighting,
              ],
            ),
            pokemonDomain.copyWith(
              name: 'anyOtherName',
            ),
          ],
        ),
      ],
    );

    blocTest<PokemonsListCubit, PokemonsListState>(
        'emits [isLoading: true] then [isLoading: false, fetchedPokemonsOrFailure: (null, PaginationResult<Pokemon>), fetchedPokemons: previously loaded pokemons + new pokemons] when requestedNextPage is called and succeeds',
        setUp: () => when(
              () => fetchPokemonsListUseCase.fetchNewPage(),
            ).thenAnswer(
              (_) async => (
                null,
                PaginationResult<Pokemon>(
                  [
                    pokemonDomain,
                  ],
                  true,
                ),
              ),
            ),
        build: () {
          return PokemonsListCubit(
            fetchPokemonsListUseCase,
            getSinglePokemonUseCase,
          );
        },
        seed: () => PokemonsListInitial().copyWith(
              fetchedPokemons: [
                pokemonDomain,
                pokemonDomain.copyWith(name: 'anyName'),
                pokemonDomain.copyWith(name: 'anyOtherName'),
              ],
            ),
        act: (cubit) => cubit.requestedNextPage(),
        expect: () => [
              PokemonsListInitial().copyWith(
                isLoading: true,
                fetchedPokemons: [
                  pokemonDomain,
                  pokemonDomain.copyWith(name: 'anyName'),
                  pokemonDomain.copyWith(name: 'anyOtherName'),
                ],
              ),
              PokemonsListInitial().copyWith(
                isLoading: false,
                fetchedPokemonsOrFailure: (
                  null,
                  PaginationResult<Pokemon>(
                    [
                      pokemonDomain,
                    ],
                    true,
                  ),
                ),
                morePagesRemaining: true,
                fetchedPokemons: [
                  pokemonDomain,
                  pokemonDomain.copyWith(name: 'anyName'),
                  pokemonDomain.copyWith(name: 'anyOtherName'),
                  pokemonDomain,
                ],
              ),
            ],
        verify: (_) {
          verify(
            () => fetchPokemonsListUseCase.fetchNewPage(),
          ).called(1);
          verifyNever(
            () => fetchPokemonsListUseCase.execute(),
          );
          verifyNever(
            () => getSinglePokemonUseCase.execute(
              any(),
            ),
          );
        });

    blocTest<PokemonsListCubit, PokemonsListState>(
      'emits [isLoading: true] then [isLoading: false, fetchedPokemonsOrFailure: (FetchPokemonsListFailure, null)] when requestedNextPage is called and fails',
      setUp: () => when(
        () => fetchPokemonsListUseCase.fetchNewPage(),
      ).thenAnswer(
        (_) async => (FetchPokemonsListFailure.unexpected, null),
      ),
      build: () {
        return PokemonsListCubit(
          fetchPokemonsListUseCase,
          getSinglePokemonUseCase,
        );
      },
      seed: () => PokemonsListInitial(),
      act: (cubit) => cubit.requestedNextPage(),
      expect: () => [
        PokemonsListInitial().copyWith(
          isLoading: true,
        ),
        PokemonsListInitial().copyWith(
          isLoading: false,
          fetchedPokemonsOrFailure: (
            FetchPokemonsListFailure.unexpected,
            null,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => fetchPokemonsListUseCase.fetchNewPage(),
        ).called(1);
        verifyNever(
          () => fetchPokemonsListUseCase.execute(),
        );
        verifyNever(
          () => getSinglePokemonUseCase.execute(
            any(),
          ),
        );
      },
    );
  });
}
