import 'package:pokemon_searcher/pokemon/domain/ability.dart';

class AbilityDto {
  final String name;

  AbilityDto({
    required this.name,
  });

  factory AbilityDto.fromJson(Map<String, dynamic> json) {
    return AbilityDto(
      name: json['name'],
    );
  }

  factory AbilityDto.fromDomain(Ability ability) {
    return AbilityDto(
      name: ability.name,
    );
  }
  Map<String, dynamic> get toJson {
    return {
      'name': name,
    };
  }

  Ability get toDomain {
    return Ability(
      name: name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AbilityDto && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
