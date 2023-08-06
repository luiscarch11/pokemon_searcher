import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_searcher/pokemon/application/pokemons_list_cubit.dart';
import 'package:pokemon_searcher/pokemon/domain/get_single_pokemon_use_case.dart';
import 'package:pokemon_searcher/pokemon/presentation/pokemon_details_page.dart';
import 'package:pokemon_searcher/shared/domain/string_constants.dart';
import 'package:pokemon_searcher/shared/presentation/infinite_scroll_widget.dart';

import '../domain/fetch_pokemons_list_use_case.dart';

class PokemonsListPage extends StatelessWidget {
  const PokemonsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonsListCubit>(
      create: (context) => PokemonsListCubit(
        context.read<FetchPokemonsListUseCase>(),
        context.read<GetSinglePokemonUseCase>(),
      )..requestedFirstTime(),
      child: const PokemonsListView(),
    );
  }
}

class PokemonsListView extends StatelessWidget {
  const PokemonsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PokemonsListCubit, PokemonsListState>(
          listenWhen: (previous, current) => previous.fetchedPokemonsOrFailure != current.fetchedPokemonsOrFailure,
          listener: (context, state) {
            if (state.fetchedPokemonsOrFailure.$1 != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.fetchedPokemonsOrFailure.$1!.errorMessage,
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<PokemonsListCubit, PokemonsListState>(
          listenWhen: (previous, current) =>
              previous.fetchedSinglePokemonOrFailure != current.fetchedSinglePokemonOrFailure,
          listener: (context, state) {
            if (state.fetchedSinglePokemonOrFailure.$1 != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.fetchedSinglePokemonOrFailure.$1!.errorMessage,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PokemonsListCubit, PokemonsListState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onChanged: context.read<PokemonsListCubit>().changedFilter,
                          onSubmitted: (_) => context.read<PokemonsListCubit>().requestedFirstTime(),
                        ),
                      ),
                      IconButton(
                        onPressed: context.read<PokemonsListCubit>().requestedFirstTime,
                        icon: const Icon(
                          Icons.search,
                        ),
                      ),
                    ],
                  ),
                  InfiniteList.unheaded(
                    loadMoreText: 'Load more',
                    dataIsOver: !state.morePagesRemaining,
                    data: state.fetchedPokemons,
                    isLoading: state.isLoading,
                    onFinishScrolling: context.read<PokemonsListCubit>().requestedNextPage,
                    itemsBuilder: (pokemon, index) {
                      final pokemon = state.fetchedPokemons[index];
                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailsPage(
                              pokemon: pokemon,
                              onPokemonChanged: context.read<PokemonsListCubit>().changedPokemon,
                            ),
                          ),
                        ),
                        title: Text(
                          pokemon.name,
                        ),
                        trailing: pokemon.customPictureUrl != null
                            ? Image.file(
                                File(pokemon.customPictureUrl!),
                              )
                            : Image.network(
                                StringConstants.pokemonImage(
                                  pokemon.number,
                                ),
                              ),
                        subtitle: Wrap(
                          children: [
                            for (final type in pokemon.types)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  StringConstants.pokemonTypeImage(
                                    type.iconName,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
