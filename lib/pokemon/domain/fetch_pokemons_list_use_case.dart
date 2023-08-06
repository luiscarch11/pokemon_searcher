import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_failure.dart';
import 'package:pokemon_searcher/shared/domain/pagination_result.dart';

abstract interface class FetchPokemonsListUseCase {
  Future<(FetchPokemonsListFailure?, PaginationResult<Pokemon>?)> execute();
  Future<(FetchPokemonsListFailure?, PaginationResult<Pokemon>?)> fetchNewPage();
}
