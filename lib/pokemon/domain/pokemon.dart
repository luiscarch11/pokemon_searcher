import 'package:flutter/foundation.dart';

import 'package:pokemon_searcher/pokemon/domain/ability.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';

import 'attack.dart';

@immutable
final class Pokemon {
  final String name;
  final int number;
  final List<PokemonType> types;
  final String? customPictureUrl;
  final List<Ability> abilities;
  final List<Attack> attacks;
  const Pokemon({
    required this.name,
    required this.number,
    required this.types,
    this.customPictureUrl,
    required this.abilities,
    required this.attacks,
  });

  Pokemon copyWith({
    String? name,
    int? number,
    List<PokemonType>? types,
    String? customPictureUrl,
    List<Ability>? abilities,
    List<Attack>? attacks,
  }) {
    return Pokemon(
      name: name ?? this.name,
      number: number ?? this.number,
      types: types ?? this.types,
      customPictureUrl: customPictureUrl ?? this.customPictureUrl,
      abilities: abilities ?? this.abilities,
      attacks: attacks ?? this.attacks,
    );
  }

  @override
  String toString() {
    return 'Pokemon(name: $name, number: $number, types: $types, customPictureUrl: $customPictureUrl, abilities: $abilities, attacks: $attacks)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pokemon &&
        other.name == name &&
        other.number == number &&
        listEquals(other.types, types) &&
        other.customPictureUrl == customPictureUrl &&
        listEquals(other.abilities, abilities) &&
        listEquals(other.attacks, attacks);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        number.hashCode ^
        types.hashCode ^
        customPictureUrl.hashCode ^
        abilities.hashCode ^
        attacks.hashCode;
  }
}
