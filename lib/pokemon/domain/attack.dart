import 'package:flutter/foundation.dart';

@immutable
class Attack {
  final String name;
  const Attack({
    required this.name,
  });

  @override
  String toString() => 'Attack(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attack && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
