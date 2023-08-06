import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/attack_dto.dart';

void main() {
  group(
    'AttackDto',
    () {
      test(
        'fromJson creates a valid AttackDto',
        () {
          final json = {
            'name': 'tackle',
          };
          final attackDto = AttackDto.fromJson(json);

          expect(
            attackDto.name,
            equals('tackle'),
          );
        },
      );

      test(
        'fromDomain creates a valid AttackDto',
        () {
          const attack = Attack(name: 'tackle');
          final attackDto = AttackDto.fromDomain(attack);

          expect(
            attackDto.name,
            equals('tackle'),
          );
        },
      );

      test(
        'toJson returns a valid JSON map',
        () {
          final attackDto = AttackDto(name: 'tackle');
          final json = attackDto.toJson;

          expect(
            json,
            equals(
              {'name': 'tackle'},
            ),
          );
        },
      );

      test(
        'toDomain creates a valid Attack',
        () {
          final attackDto = AttackDto(
            name: 'tackle',
          );
          final attack = attackDto.toDomain;

          expect(
            attack.name,
            equals('tackle'),
          );
        },
      );
    },
  );
}
