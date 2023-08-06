import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/application/pokemons_list_cubit.dart';

import '../domain/pokemon_test.dart';

void main() {
  group(
    'PokemonsListState\n',
    () {
      test(
        'two instances with the same properties should be equal',
        () {
          const state1 = PokemonsListState(
            fetchedPokemonsOrFailure: (null, null),
            fetchedSinglePokemonOrFailure: (null, null),
            fetchedPokemons: [],
            nameFilter: '',
            isLoading: false,
            morePagesRemaining: false,
          );
          const state2 = PokemonsListState(
            fetchedPokemonsOrFailure: (null, null),
            fetchedSinglePokemonOrFailure: (null, null),
            fetchedPokemons: [],
            nameFilter: '',
            isLoading: false,
            morePagesRemaining: false,
          );
          expect(
            state1,
            equals(state2),
          );
        },
      );

      test(
        'copyWith should return a new instance with the updated properties',
        () {
          const state1 = PokemonsListState(
            fetchedPokemonsOrFailure: (null, null),
            fetchedSinglePokemonOrFailure: (null, null),
            fetchedPokemons: [],
            nameFilter: '',
            isLoading: false,
            morePagesRemaining: false,
          );
          final state2 = state1.copyWith(
            isLoading: true,
            fetchedPokemons: [
              pokemonDomain,
            ],
          );
          expect(
            state2.isLoading,
            isTrue,
          );
          expect(
            state2.fetchedPokemons,
            equals(
              [pokemonDomain],
            ),
          );
          expect(
            state1,
            isNot(
              equals(state2),
            ),
          );
        },
      );
      test(
        'PokemonsListInitial should have expected values',
        () {
          final state = PokemonsListInitial();
          expect(
            state.fetchedPokemons,
            equals([]),
          );
          expect(
            state.isLoading,
            isFalse,
          );
          expect(
            state.nameFilter,
            equals(''),
          );
          expect(
            state.morePagesRemaining,
            isFalse,
          );
        },
      );
    },
  );
}
