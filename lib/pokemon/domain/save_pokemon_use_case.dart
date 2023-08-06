import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/save_pokemon_failure.dart';

abstract interface class SavePokemonUseCase {
  Future<SavePokemonFailure?> execute(Pokemon pokemon);
}
