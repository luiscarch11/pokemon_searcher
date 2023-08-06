import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_use_case.dart';

part 'pokemon_details_state.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetailsState> {
  PokemonDetailsCubit(this._updatePokemonImageUseCase)
      : super(
          const PokemonDetailsInitial(),
        );
  final UpdatePokemonImageUseCase _updatePokemonImageUseCase;
  Future<void> selectedNewImage(Pokemon pokemon, String uri) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final failure = await _updatePokemonImageUseCase.execute(
      pokemon,
      uri,
    );

    emit(
      state.copyWith(
        isLoading: false,
        updatePokemonImageFailure: failure,
        imageToShow: failure == null ? uri : null,
      ),
    );
  }
}
