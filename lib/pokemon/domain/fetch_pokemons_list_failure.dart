enum FetchPokemonsListFailure {
  unexpected,
  errorFetchingIndividualPokemon;

  String get errorMessage => switch (this) {
        FetchPokemonsListFailure.unexpected => 'Unexpected error',
        FetchPokemonsListFailure.errorFetchingIndividualPokemon => 'Error fetching individual pokemon',
      };
}
