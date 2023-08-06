enum GetSinglePokemonFailure {
  unknown;

  String get errorMessage => switch (this) {
        GetSinglePokemonFailure.unknown => 'Unknown error',
      };
}
