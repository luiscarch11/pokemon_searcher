import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/ability_dto.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/attack_dto.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/pokemon_dto.dart';

import '../domain/pokemon_test.dart';

void main() {
  group(
    'PokemonDto',
    () {
      test(
        'fromJson creates a valid PokemonDto',
        () {
          final json = {
            'id': 1,
            'name': 'bulbasaur',
            'types': [
              {
                'type': {
                  'name': 'grass',
                },
              },
              {
                'type': {
                  'name': 'poison',
                },
              },
            ],
            'moves': [
              {
                'move': {
                  'name': 'razor-wind',
                },
              },
              {
                'move': {
                  'name': 'swords-dance',
                },
              },
            ],
            'abilities': [
              {
                'ability': {
                  'name': 'razor-wind',
                },
              },
              {
                'ability': {
                  'name': 'swords-dance',
                },
              },
            ]
          };
          final pokemonDto = PokemonDto.fromJson(json);

          expect(
            pokemonDto.number,
            equals(1),
          );
          expect(
            pokemonDto.name,
            equals('bulbasaur'),
          );
          expect(
            pokemonDto.abilities,
            equals(
              [
                AbilityDto(
                  name: 'razor-wind',
                ),
                AbilityDto(
                  name: 'swords-dance',
                ),
              ],
            ),
          );
          expect(
            pokemonDto.customPictureUrl,
            isNull,
          );
          expect(
            pokemonDto.types,
            equals(
              [
                'grass',
                'poison',
              ],
            ),
          );
          expect(
            pokemonDto.attacks,
            equals(
              [
                AttackDto(
                  name: 'razor-wind',
                ),
                AttackDto(
                  name: 'swords-dance',
                ),
              ],
            ),
          );
        },
      );

      test(
        'fromDomain creates a valid PokemonDto',
        () {
          const pokemon = pokemonDomain;
          final pokemonDto = PokemonDto.fromDomain(pokemon);
          expect(
            pokemonDto.number,
            equals(1),
          );
          expect(
            pokemonDto.name,
            equals('Bulbasaur'),
          );
          expect(
            pokemonDto.abilities,
            equals(
              [
                AbilityDto(
                  name: 'Overgrow',
                ),
              ],
            ),
          );
          expect(
            pokemonDto.customPictureUrl,
            isNull,
          );
          expect(
            pokemonDto.types,
            equals(
              [
                'grass',
                'poison',
              ],
            ),
          );
          expect(
            pokemonDto.attacks,
            equals(
              [
                AttackDto(
                  name: 'Tackle',
                ),
              ],
            ),
          );
        },
      );

      test(
        'toJson returns a valid JSON map',
        () {
          final pokemonDto = PokemonDto(
            customPictureUrl: null,
            number: 1,
            abilities: [
              AbilityDto(
                name: 'overgrow',
              ),
              AbilityDto(
                name: 'chlorophyll',
              ),
            ],
            name: 'bulbasaur',
            types: [
              'grass',
              'poison',
            ],
            attacks: [
              AttackDto(
                name: 'razor-wind',
              ),
              AttackDto(
                name: 'swords-dance',
              ),
            ],
          );
          final json = pokemonDto.toJson;

          expect(
            json,
            equals(
              {
                'id': 1,
                'name': 'bulbasaur',
                'types': [
                  'grass',
                  'poison',
                ],
                'moves': [
                  {
                    'name': 'razor-wind',
                  },
                  {
                    'name': 'swords-dance',
                  },
                ],
                'abilities': [
                  {
                    'name': 'overgrow',
                  },
                  {
                    'name': 'chlorophyll',
                  },
                ],
                'custom_picture_url': null,
              },
            ),
          );
        },
      );

      test(
        'toDomain creates a valid Pokemon',
        () {
          final pokemonDto = PokemonDto(
            number: 1,
            name: 'bulbasaur',
            types: [
              'grass',
              'poison',
            ],
            abilities: [
              AbilityDto(
                name: 'overgrow',
              ),
              AbilityDto(
                name: 'chlorophyll',
              ),
            ],
            attacks: [
              AttackDto(
                name: 'razor-wind',
              ),
              AttackDto(
                name: 'swords-dance',
              ),
            ],
            customPictureUrl: 'https://example.com',
          );
          final pokemon = pokemonDto.toDomain;

          expect(
            pokemon,
            equals(
              const Pokemon(
                number: 1,
                name: 'bulbasaur',
                types: [
                  PokemonType.grass,
                  PokemonType.poison,
                ],
                abilities: [
                  Ability(
                    name: 'overgrow',
                  ),
                  Ability(
                    name: 'chlorophyll',
                  ),
                ],
                attacks: [
                  Attack(
                    name: 'razor-wind',
                  ),
                  Attack(
                    name: 'swords-dance',
                  ),
                ],
                customPictureUrl: 'https://example.com',
              ),
            ),
          );
        },
      );
    },
  );
}
