import 'package:flutter/material.dart';

@immutable
final class Ability {
  final String name;
  const Ability({
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ability && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
