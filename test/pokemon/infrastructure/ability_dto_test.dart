import 'package:flutter_test/flutter_test.dart';

import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/ability_dto.dart';

void main() {
  group(
    'AbilityDto',
    () {
      test(
        'fromJson creates a valid AbilityDto',
        () {
          final json = {'name': 'overgrow'};
          final abilityDto = AbilityDto.fromJson(json);

          expect(
            abilityDto.name,
            equals('overgrow'),
          );
        },
      );

      test(
        'fromDomain creates a valid AbilityDto',
        () {
          const ability = Ability(
            name: 'overgrow',
          );
          final abilityDto = AbilityDto.fromDomain(ability);

          expect(
            abilityDto.name,
            equals('overgrow'),
          );
        },
      );

      test(
        'toJson returns a valid JSON map',
        () {
          final abilityDto = AbilityDto(
            name: 'overgrow',
          );
          final json = abilityDto.toJson;

          expect(
            json,
            equals(
              {
                'name': 'overgrow',
              },
            ),
          );
        },
      );

      test(
        'toDomain creates a valid Ability',
        () {
          final abilityDto = AbilityDto(name: 'overgrow');
          final ability = abilityDto.toDomain;

          expect(
            ability.name,
            'overgrow',
          );
          expect(
            ability,
            equals(
              const Ability(
                name: 'overgrow',
              ),
            ),
          );
        },
      );
    },
  );
}
