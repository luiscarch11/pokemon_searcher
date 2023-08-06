import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';

abstract interface class UpdatePokemonImageUseCase {
  Future<UpdatePokemonImageFailure?> execute(
    Pokemon pokemon,
    String imageUri,
  );
}
