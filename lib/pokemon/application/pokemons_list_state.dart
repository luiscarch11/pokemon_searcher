part of 'pokemons_list_cubit.dart';

@immutable
class PokemonsListState {
  final (FetchPokemonsListFailure?, PaginationResult<Pokemon>?) fetchedPokemonsOrFailure;
  final (GetSinglePokemonFailure?, Pokemon?) fetchedSinglePokemonOrFailure;
  final bool isLoading;
  final List<Pokemon> fetchedPokemons;
  final String nameFilter;
  final bool morePagesRemaining;
  const PokemonsListState({
    required this.fetchedPokemonsOrFailure,
    required this.fetchedSinglePokemonOrFailure,
    required this.isLoading,
    required this.fetchedPokemons,
    required this.nameFilter,
    required this.morePagesRemaining,
  });

  PokemonsListState copyWith({
    (FetchPokemonsListFailure?, PaginationResult<Pokemon>?)? fetchedPokemonsOrFailure,
    (GetSinglePokemonFailure?, Pokemon?)? fetchedSinglePokemonOrFailure,
    bool? isLoading,
    List<Pokemon>? fetchedPokemons,
    String? nameFilter,
    bool? morePagesRemaining,
  }) {
    return PokemonsListState(
      fetchedPokemonsOrFailure: fetchedPokemonsOrFailure ?? this.fetchedPokemonsOrFailure,
      fetchedSinglePokemonOrFailure: fetchedSinglePokemonOrFailure ?? this.fetchedSinglePokemonOrFailure,
      isLoading: isLoading ?? this.isLoading,
      fetchedPokemons: fetchedPokemons ?? this.fetchedPokemons,
      nameFilter: nameFilter ?? this.nameFilter,
      morePagesRemaining: morePagesRemaining ?? this.morePagesRemaining,
    );
  }

  @override
  String toString() {
    return 'PokemonsListState(fetchedPokemonsOrFailure: $fetchedPokemonsOrFailure, fetchedSinglePokemonOrFailure: $fetchedSinglePokemonOrFailure, isLoading: $isLoading, fetchedPokemons: $fetchedPokemons, nameFilter: $nameFilter, morePagesRemaining: $morePagesRemaining)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PokemonsListState &&
        other.fetchedPokemonsOrFailure == fetchedPokemonsOrFailure &&
        other.fetchedSinglePokemonOrFailure == fetchedSinglePokemonOrFailure &&
        other.isLoading == isLoading &&
        listEquals(other.fetchedPokemons, fetchedPokemons) &&
        other.nameFilter == nameFilter &&
        other.morePagesRemaining == morePagesRemaining;
  }

  @override
  int get hashCode {
    return fetchedPokemonsOrFailure.hashCode ^
        fetchedSinglePokemonOrFailure.hashCode ^
        isLoading.hashCode ^
        fetchedPokemons.hashCode ^
        nameFilter.hashCode ^
        morePagesRemaining.hashCode;
  }
}

class PokemonsListInitial extends PokemonsListState {
  PokemonsListInitial()
      : super(
          fetchedPokemonsOrFailure: (null, null),
          fetchedSinglePokemonOrFailure: (null, null),
          fetchedPokemons: [],
          nameFilter: '',
          isLoading: false,
          morePagesRemaining: false,
        );
}
