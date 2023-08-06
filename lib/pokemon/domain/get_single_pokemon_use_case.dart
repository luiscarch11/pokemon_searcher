import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';

abstract interface class GetSinglePokemonUseCase {
  Future<(GetSinglePokemonFailure?, Pokemon?)> execute(String name);
}
