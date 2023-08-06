import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/application/pokemon_details/pokemon_details_cubit.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';

void main() {
  group(
    'PokemonDetailsState',
    () {
      test(
        'two PokemonDetailsState objects with the same values are equal',
        () {
          const state1 = PokemonDetailsState(
            updatePokemonImageFailure: null,
            isLoading: false,
            imageToShow: '',
          );
          const state2 = PokemonDetailsState(
            updatePokemonImageFailure: null,
            isLoading: false,
            imageToShow: '',
          );

          expect(
            state1 == state2,
            isTrue,
          );
        },
      );
      test(
        'copyWith returns previous values if not specified',
        () {
          const state1 = PokemonDetailsState(
            updatePokemonImageFailure: UpdatePokemonImageFailure.unknown,
            isLoading: true,
            imageToShow: 'https://example.com/image.png',
          );
          final state2 = state1.copyWith();

          expect(
            state2.updatePokemonImageFailure,
            UpdatePokemonImageFailure.unknown,
          );
          expect(
            state2.isLoading,
            isTrue,
          );
          expect(
            state2.imageToShow,
            equals('https://example.com/image.png'),
          );
        },
      );
      test(
        'copyWith returns a new PokemonDetailsState with the specified fields updated',
        () {
          const state1 = PokemonDetailsState(
            updatePokemonImageFailure: null,
            isLoading: false,
            imageToShow: '',
          );
          final state2 = state1.copyWith(
            updatePokemonImageFailure: UpdatePokemonImageFailure.unknown,
            isLoading: true,
            imageToShow: 'https://example.com/image.png',
          );

          expect(
            state2.updatePokemonImageFailure,
            UpdatePokemonImageFailure.unknown,
          );
          expect(
            state2.isLoading,
            isTrue,
          );
          expect(
            state2.imageToShow,
            equals('https://example.com/image.png'),
          );
        },
      );

      test(
        'PokemonDetailsInitial has the correct values',
        () {
          const initial = PokemonDetailsInitial();

          expect(
            initial.updatePokemonImageFailure,
            null,
          );
          expect(
            initial.isLoading,
            false,
          );
          expect(
            initial.imageToShow,
            '',
          );
        },
      );
    },
  );
}
