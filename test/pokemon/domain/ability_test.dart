import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/domain/ability.dart';

void main() {
  group(
    'Ability',
    () {
      test(
        'two abilities with the same name are equal',
        () {
          const ability1 = Ability(
            name: 'Overgrow',
          );
          const ability2 = Ability(
            name: 'Overgrow',
          );

          expect(
            ability1,
            ability2,
          );
        },
      );

      test(
        'two abilities with different names are not equal',
        () {
          const ability1 = Ability(
            name: 'Overgrow',
          );
          const ability2 = Ability(
            name: 'Chlorophyll',
          );

          expect(
            ability1,
            isNot(ability2),
          );
        },
      );
    },
  );
}
