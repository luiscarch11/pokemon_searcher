import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:pokemon_searcher/pokemon/application/pokemon_details/pokemon_details_cubit.dart';

import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';
import '../../domain/pokemon_test.dart';

class MockUpdatePokemonImageUseCase extends Mock implements UpdatePokemonImageUseCase {}

void main() {
  group(
    'PokemonDetailsCubit',
    () {
      const pokemon = pokemonDomain;
      const uri = 'https://example.com/image.png';
      const failure = UpdatePokemonImageFailure.unknown;

      late UpdatePokemonImageUseCase mockUpdatePokemonImageUseCase;
      late PokemonDetailsCubit pokemonDetailsCubit;

      setUp(
        () {
          mockUpdatePokemonImageUseCase = MockUpdatePokemonImageUseCase();
          pokemonDetailsCubit = PokemonDetailsCubit(mockUpdatePokemonImageUseCase);
        },
      );

      test(
        'initial state is PokemonDetailsInitial',
        () {
          expect(
            pokemonDetailsCubit.state,
            const PokemonDetailsInitial(),
          );
        },
      );

      blocTest<PokemonDetailsCubit, PokemonDetailsState>(
        'emits [isLoading=true, isLoading=false, imageToShow=uri] when selectedNewImage is called successfully',
        setUp: () {
          when(
            () => mockUpdatePokemonImageUseCase.execute(
              pokemon,
              uri,
            ),
          ).thenAnswer(
            (_) async => null,
          );
        },
        build: () {
          return pokemonDetailsCubit;
        },
        act: (cubit) => cubit.selectedNewImage(pokemon, uri),
        expect: () => [
          const PokemonDetailsInitial().copyWith(
            isLoading: true,
          ),
          const PokemonDetailsState(
            isLoading: false,
            updatePokemonImageFailure: null,
            imageToShow: uri,
          ),
        ],
      );

      blocTest<PokemonDetailsCubit, PokemonDetailsState>(
        'emits [isLoading=true, isLoading=false, updatePokemonImageFailure=failure] when selectedNewImage fails',
        setUp: () => when(
          () => mockUpdatePokemonImageUseCase.execute(
            pokemon,
            uri,
          ),
        ).thenAnswer(
          (_) async => failure,
        ),
        build: () {
          return pokemonDetailsCubit;
        },
        act: (cubit) => cubit.selectedNewImage(pokemon, uri),
        expect: () => [
          const PokemonDetailsInitial().copyWith(
            isLoading: true,
          ),
          const PokemonDetailsState(
            isLoading: false,
            updatePokemonImageFailure: failure,
            imageToShow: '',
          ),
        ],
      );
    },
  );
}
