import 'package:flutter/foundation.dart';

final class PaginationResult<T> {
  final List<T> items;
  final bool morePagesRemaining;

  PaginationResult(
    this.items,
    this.morePagesRemaining,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationResult<T> &&
        listEquals(other.items, items) &&
        other.morePagesRemaining == morePagesRemaining;
  }

  @override
  int get hashCode => items.hashCode ^ morePagesRemaining.hashCode;
}
