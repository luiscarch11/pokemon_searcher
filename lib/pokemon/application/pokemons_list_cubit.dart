import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/shared/domain/pagination_result.dart';

import '../domain/pokemon.dart';
import '../domain/fetch_pokemons_list_failure.dart';
import '../domain/fetch_pokemons_list_use_case.dart';

part 'pokemons_list_state.dart';

class PokemonsListCubit extends Cubit<PokemonsListState> {
  PokemonsListCubit(
    this._fetchPokemonsListUseCase,
    this._getSinglePokemonUseCase,
  ) : super(
          PokemonsListInitial(),
        );
  final FetchPokemonsListUseCase _fetchPokemonsListUseCase;
  final GetSinglePokemonUseCase _getSinglePokemonUseCase;
  void changedFilter(String filter) {
    emit(
      state.copyWith(
        nameFilter: filter,
      ),
    );
  }

  Future<void> requestedFirstTime() async {
    if (state.nameFilter.isNotEmpty) {
      final fetchedPokemons = List<Pokemon>.from(
        state.fetchedPokemons,
      );

      emit(
        state.copyWith(
          isLoading: true,
          fetchedPokemons: [],
        ),
      );
      final result = await _getSinglePokemonUseCase.execute(
        state.nameFilter,
      );

      emit(
        state.copyWith(
          isLoading: false,
          fetchedSinglePokemonOrFailure: result,
          fetchedPokemons: result.$1 == null
              ? [
                  result.$2!,
                ]
              : fetchedPokemons,
          morePagesRemaining: result.$1 == null ? false : null,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final (failure, pokemons) = await _fetchPokemonsListUseCase.execute();
    emit(
      state.copyWith(
        isLoading: false,
        fetchedPokemonsOrFailure: (failure, pokemons),
        fetchedPokemons: pokemons?.items ?? [],
        morePagesRemaining: pokemons?.morePagesRemaining,
      ),
    );
  }

  void changedPokemon(Pokemon pokemon) {
    final listToEmit = List<Pokemon>.from(
      state.fetchedPokemons,
    );
    final index = listToEmit.indexWhere(
      (element) => element.name == pokemon.name,
    );
    if (index == -1) {
      return;
    }
    listToEmit[index] = pokemon;
    emit(
      state.copyWith(
        fetchedPokemons: listToEmit,
      ),
    );
  }

  Future<void> requestedNextPage() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final (failure, pokemons) = await _fetchPokemonsListUseCase.fetchNewPage();
    final newPokemonsList = List<Pokemon>.from(
      state.fetchedPokemons,
    );
    if (pokemons != null) {
      newPokemonsList.addAll(
        pokemons.items,
      );
    }
    emit(
      state.copyWith(
        isLoading: false,
        fetchedPokemonsOrFailure: (failure, pokemons),
        fetchedPokemons: newPokemonsList,
        morePagesRemaining: pokemons?.morePagesRemaining,
      ),
    );
  }
}
