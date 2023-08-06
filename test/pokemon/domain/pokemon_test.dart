import 'package:flutter_test/flutter_test.dart';

import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';

void main() {
  group(
    'Pokemon',
    () {
      const pokemon = pokemonDomain;

      test(
        'copyWith returns a new Pokemon with the specified fields updated',
        () {
          final updatedPokemon = pokemon.copyWith(
            name: 'Ivysaur',
            types: [
              PokemonType.grass,
              PokemonType.poison,
              PokemonType.flying,
            ],
            customPictureUrl: 'https://example.com/image.png',
            abilities: [
              const Ability(
                name: 'Overgrow',
              ),
              const Ability(
                name: 'Chlorophyll',
              ),
            ],
            attacks: [
              const Attack(
                name: 'Tackle',
              ),
              const Attack(
                name: 'Vine Whip',
              ),
            ],
          );

          expect(
            updatedPokemon.name,
            'Ivysaur',
          );
          expect(updatedPokemon.types, [
            PokemonType.grass,
            PokemonType.poison,
            PokemonType.flying,
          ]);
          expect(
            updatedPokemon.customPictureUrl,
            'https://example.com/image.png',
          );
          expect(updatedPokemon.abilities, [
            const Ability(
              name: 'Overgrow',
            ),
            const Ability(
              name: 'Chlorophyll',
            ),
          ]);
          expect(
            updatedPokemon.attacks,
            [
              const Attack(
                name: 'Tackle',
              ),
              const Attack(
                name: 'Vine Whip',
              ),
            ],
          );
        },
      );

      test(
        'copyWith returns a new Pokemon with the same fields when no fields are updated',
        () {
          final updatedPokemon = pokemon.copyWith();

          expect(
            updatedPokemon,
            pokemon,
          );
        },
      );
      group(
        'value comparisons should return ',
        () {
          test(
            ' true if all properties are the same',
            () {
              const samePokemon = Pokemon(
                name: 'Bulbasaur',
                number: 1,
                types: [
                  PokemonType.grass,
                  PokemonType.poison,
                ],
                customPictureUrl: null,
                abilities: [
                  Ability(name: 'Overgrow'),
                ],
                attacks: [
                  Attack(
                    name: 'Tackle',
                  ),
                ],
              );

              expect(
                samePokemon == pokemon,
                isTrue,
              );
            },
          );

          test(
            ' false if any of the properties is different',
            () {
              const differentPokemon = Pokemon(
                name: 'Ivysaur',
                number: 2,
                types: [
                  PokemonType.grass,
                  PokemonType.poison,
                ],
                customPictureUrl: null,
                abilities: [
                  Ability(name: 'Overgrow'),
                ],
                attacks: [
                  Attack(
                    name: 'Tackle',
                  ),
                ],
              );

              expect(
                differentPokemon == pokemon,
                isFalse,
              );
            },
          );
        },
      );
    },
  );
}

const pokemonDomain = Pokemon(
  name: 'Bulbasaur',
  number: 1,
  types: [
    PokemonType.grass,
    PokemonType.poison,
  ],
  customPictureUrl: null,
  abilities: [
    Ability(name: 'Overgrow'),
  ],
  attacks: [
    Attack(
      name: 'Tackle',
    ),
  ],
);
