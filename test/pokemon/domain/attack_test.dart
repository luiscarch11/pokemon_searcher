import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_searcher/pokemon/domain/attack.dart';

void main() {
  group(
    'Attack tests\n',
    () {
      test(
        'comparing two attacks with the same name should return true',
        () {
          const attack1 = Attack(
            name: 'Tackle',
          );
          const attack2 = Attack(
            name: 'Tackle',
          );

          expect(
            attack1,
            attack2,
          );
        },
      );

      test(
        'two attacks with different names are not equal',
        () {
          const attack1 = Attack(
            name: 'Tackle',
          );
          const attack2 = Attack(
            name: 'Vine Whip',
          );

          expect(
            attack1,
            isNot(attack2),
          );
        },
      );
    },
  );
}
