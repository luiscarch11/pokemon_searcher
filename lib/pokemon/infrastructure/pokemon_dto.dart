import 'package:flutter/foundation.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon.dart';
import 'package:pokemon_searcher/pokemon/domain/pokemon_type.dart';

import 'package:pokemon_searcher/pokemon/infrastructure/ability_dto.dart';
import 'package:pokemon_searcher/pokemon/infrastructure/attack_dto.dart';

final class PokemonDto {
  @visibleForTesting
  const PokemonDto({
    required this.name,
    required this.customPictureUrl,
    required this.number,
    required this.types,
    required this.abilities,
    required this.attacks,
  });
  final String? customPictureUrl;
  final String name;
  final int number;
  final List<String> types;
  final List<AbilityDto> abilities;
  final List<AttackDto> attacks;

  static PokemonDto fromJson(Map<String, dynamic> json) {
    return PokemonDto(
      customPictureUrl: null,
      name: json['name'],
      number: json['id'],
      types: (json['types'] as List)
          .map(
            (e) => ((e as Map<String, dynamic>)['type'] as Map<String, dynamic>)['name'] as String,
          )
          .toList(),
      abilities: (json['abilities'] as List)
          .map(
            (e) => AbilityDto.fromJson(
              ((e as Map<String, dynamic>)['ability']) as Map<String, dynamic>,
            ),
          )
          .toList(),
      attacks: (json['moves'] as List)
          .map(
            (e) => AttackDto.fromJson(
              ((e as Map<String, dynamic>)['move']) as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  static PokemonDto fromLocalJson(Map<String, dynamic> json) {
    return PokemonDto(
      customPictureUrl: json['custom_picture_url'],
      name: json['name'],
      number: json['id'],
      types: (json['types'] as List)
          .map(
            (e) => e as String,
          )
          .toList(),
      abilities: (json['abilities'] as List)
          .map(
            (e) => AbilityDto.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      attacks: (json['moves'] as List)
          .map(
            (e) => AttackDto.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> get toJson {
    return {
      'name': name,
      'id': number,
      'types': types,
      'abilities': abilities
          .map(
            (e) => e.toJson,
          )
          .toList(),
      'custom_picture_url': customPictureUrl,
      'moves': attacks
          .map(
            (e) => e.toJson,
          )
          .toList(),
    };
  }

  static PokemonDto fromDomain(Pokemon domain) {
    return PokemonDto(
        customPictureUrl: domain.customPictureUrl,
        name: domain.name,
        number: domain.number,
        types: domain.types
            .map(
              (e) => e.name,
            )
            .toList(),
        abilities: domain.abilities
            .map(
              (e) => AbilityDto.fromDomain(e),
            )
            .toList(),
        attacks: domain.attacks
            .map(
              (e) => AttackDto.fromDomain(e),
            )
            .toList());
  }

  Pokemon get toDomain {
    return Pokemon(
      name: name,
      customPictureUrl: customPictureUrl,
      number: number,
      types: types
          .map(
            (e) => PokemonType.fromString(e),
          )
          .toList(),
      abilities: abilities
          .map(
            (e) => e.toDomain,
          )
          .toList(),
      attacks: attacks
          .map(
            (e) => e.toDomain,
          )
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PokemonDto &&
        other.customPictureUrl == customPictureUrl &&
        other.name == name &&
        other.number == number &&
        listEquals(other.types, types) &&
        listEquals(other.abilities, abilities) &&
        listEquals(other.attacks, attacks);
  }

  @override
  int get hashCode {
    return customPictureUrl.hashCode ^
        name.hashCode ^
        number.hashCode ^
        types.hashCode ^
        abilities.hashCode ^
        attacks.hashCode;
  }
}
