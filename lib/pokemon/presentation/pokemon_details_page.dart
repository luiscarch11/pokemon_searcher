import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_failure.dart';
import 'package:pokemon_searcher/pokemon/domain/update_pokemon_image_use_case.dart';

import '../../shared/domain/string_constants.dart';
import '../application/pokemon_details/pokemon_details_cubit.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({
    super.key,
    required this.pokemon,
    required this.onPokemonChanged,
  });
  final Pokemon pokemon;
  final ValueChanged<Pokemon> onPokemonChanged;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (ctx) => PokemonDetailsCubit(
          context.read<UpdatePokemonImageUseCase>(),
        ),
        child: PokemonDetailsView(
          pokemon: pokemon,
          onPokemonChanged: onPokemonChanged,
        ),
      ),
    );
  }
}

@visibleForTesting
class PokemonDetailsView extends StatelessWidget {
  const PokemonDetailsView({super.key, required this.pokemon, required this.onPokemonChanged});
  final Pokemon pokemon;
  final ValueChanged<Pokemon> onPokemonChanged;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PokemonDetailsCubit, PokemonDetailsState>(
          listenWhen: (previous, current) => previous.updatePokemonImageFailure != current.updatePokemonImageFailure,
          listener: (context, state) {
            if (state.updatePokemonImageFailure != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    switch (state.updatePokemonImageFailure!) {
                      UpdatePokemonImageFailure.unknown => 'Unknown error',
                    },
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<PokemonDetailsCubit, PokemonDetailsState>(
          listenWhen: (previous, current) => previous.imageToShow != current.imageToShow,
          listener: (context, state) {
            if (state.imageToShow.isNotEmpty) {
              onPokemonChanged(
                pokemon.copyWith(
                  customPictureUrl: state.imageToShow,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<PokemonDetailsCubit, PokemonDetailsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                sliver: SliverLayoutBuilder(
                  builder: (ctx, constr) => SliverToBoxAdapter(
                    child: SizedBox(
                      width: constr.crossAxisExtent,
                      height: constr.viewportMainAxisExtent / 2,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showBottomSheet(
                                context: context,
                                builder: (_) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Select where you want to pick the image from:',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    ListTile(
                                      leading: const Text('Camera'),
                                      onTap: () {
                                        ImagePicker()
                                            .pickImage(
                                          source: ImageSource.camera,
                                        )
                                            .then(
                                          (value) {
                                            if (value != null) {
                                              Navigator.pop(context);
                                              context.read<PokemonDetailsCubit>().selectedNewImage(
                                                    pokemon,
                                                    value.path,
                                                  );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        ImagePicker()
                                            .pickImage(
                                          source: ImageSource.gallery,
                                        )
                                            .then(
                                          (value) {
                                            if (value != null) {
                                              Navigator.pop(context);
                                              context.read<PokemonDetailsCubit>().selectedNewImage(
                                                    pokemon,
                                                    value.path,
                                                  );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: (state.imageToShow.isNotEmpty || pokemon.customPictureUrl != null)
                                ? Image.file(
                                    File(
                                      state.imageToShow.isEmpty ? pokemon.customPictureUrl! : state.imageToShow,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  )
                                : Image.network(
                                    StringConstants.pokemonImage(
                                      pokemon.number,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: Center(
                    child: Text(
                      pokemon.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                    right: 8,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Abilities',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Attacks',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                sliver: SliverFillRemaining(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: pokemon.abilities.length,
                          itemBuilder: (ctx, index) {
                            return Center(
                              child: Text(
                                pokemon.abilities[index].name,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pokemon.attacks.length,
                          itemBuilder: (ctx, index) {
                            return Center(
                              child: Text(
                                pokemon.attacks[index].name,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
