import 'package:pokemon_searcher/pokemon/domain/attack.dart';

class AttackDto {
  final String name;

  AttackDto({
    required this.name,
  });

  factory AttackDto.fromJson(Map<String, dynamic> json) {
    return AttackDto(
      name: json['name'],
    );
  }

  factory AttackDto.fromDomain(Attack attack) {
    return AttackDto(
      name: attack.name,
    );
  }
  Map<String, dynamic> get toJson {
    return {
      'name': name,
    };
  }

  Attack get toDomain {
    return Attack(
      name: name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttackDto && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
