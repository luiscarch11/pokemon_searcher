import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/fetch_pokemons_list_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/shared/domain/pagination_result.dart';
import 'package:pokemon_searcher/shared/domain/string_constants.dart';

final class HTTPFetchPokemonsListUseCase implements FetchPokemonsListUseCase {
  final GetSinglePokemonUseCase _getSinglePokemonUseCase;

  final PokemonListFetcher _pokemonFetcher;
  HTTPFetchPokemonsListUseCase(
    http.Client client,
    this._getSinglePokemonUseCase, [
    @visibleForTesting PokemonListFetcher? pokemonFetcher,
  ]) : _pokemonFetcher = pokemonFetcher ?? PokemonListFetcher(client);
  String? nextPageUrl;
  @override
  Future<(FetchPokemonsListFailure?, PaginationResult<Pokemon>?)> execute() async {
    const url = StringConstants.getPokemonsEndpointUrl;
    final (failure, result) = await _pokemonFetcher.execute(url);
    if (failure != null) {
      return (
        failure,
        null,
      );
    }
    nextPageUrl = result!.nextPageUrl;
    final pokemonsToReturn = <Pokemon>[];
    for (final pokemonName in result.pokemonNames) {
      final (failure, pokemonDetails) = await _getSinglePokemonUseCase.execute(pokemonName);
      if (failure != null) {
        return (
          FetchPokemonsListFailure.errorFetchingIndividualPokemon,
          null,
        );
      }
      pokemonsToReturn.add(
        pokemonDetails!,
      );
    }
    return (
      null,
      PaginationResult(
        pokemonsToReturn,
        nextPageUrl != null,
      ),
    );
  }

  @override
  Future<(FetchPokemonsListFailure?, PaginationResult<Pokemon>?)> fetchNewPage() async {
    if (nextPageUrl == null) {
      return (
        null,
        PaginationResult(
          <Pokemon>[],
          false,
        ),
      );
    }

    final (failure, result) = await _pokemonFetcher.execute(nextPageUrl!);
    if (failure != null) {
      return (
        failure,
        null,
      );
    }
    nextPageUrl = result!.nextPageUrl;
    final pokemonsToReturn = <Pokemon>[];
    for (final pokemonName in result.pokemonNames) {
      final (failure, pokemonDetails) = await _getSinglePokemonUseCase.execute(pokemonName);
      if (failure != null) {
        return (
          FetchPokemonsListFailure.errorFetchingIndividualPokemon,
          null,
        );
      }
      pokemonsToReturn.add(
        pokemonDetails!,
      );
    }
    return (
      null,
      PaginationResult(
        pokemonsToReturn,
        nextPageUrl != null,
      ),
    );
  }
}

@visibleForTesting
class PokemonListFetcher {
  final http.Client _client;

  PokemonListFetcher(this._client);
  Future<(FetchPokemonsListFailure?, PokemonListFetcherResult?)> execute(String url) async {
    try {
      final uri = Uri.parse(
        url,
      );
      final result = await _client.get(
        uri,
      );
      final responseData = jsonDecode(
        result.body,
      ) as Map<String, dynamic>;
      if (responseData['next'] == null) {
        return (
          FetchPokemonsListFailure.unexpected,
          null,
        );
      }
      final pokemons = responseData['results'] as List;

      return (
        null,
        PokemonListFetcherResult(
          responseData['next'] as String,
          pokemons
              .map(
                (e) => (e as Map<String, dynamic>)['name'] as String,
              )
              .toList(),
        ),
      );
    } catch (_) {
      return (
        FetchPokemonsListFailure.unexpected,
        null,
      );
    }
  }
}

@visibleForTesting
class PokemonListFetcherResult {
  final String? nextPageUrl;
  final List<String> pokemonNames;
  PokemonListFetcherResult(
    this.nextPageUrl,
    this.pokemonNames,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PokemonListFetcherResult &&
        other.nextPageUrl == nextPageUrl &&
        listEquals(other.pokemonNames, pokemonNames);
  }

  @override
  int get hashCode => nextPageUrl.hashCode ^ pokemonNames.hashCode;
}
