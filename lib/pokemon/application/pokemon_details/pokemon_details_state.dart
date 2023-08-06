part of 'pokemon_details_cubit.dart';

@immutable
class PokemonDetailsState {
  final UpdatePokemonImageFailure? updatePokemonImageFailure;
  final bool isLoading;
  final String imageToShow;
  const PokemonDetailsState({
    this.updatePokemonImageFailure,
    required this.isLoading,
    required this.imageToShow,
  });

  PokemonDetailsState copyWith({
    UpdatePokemonImageFailure? updatePokemonImageFailure,
    bool? isLoading,
    String? imageToShow,
  }) {
    return PokemonDetailsState(
      updatePokemonImageFailure: updatePokemonImageFailure ?? this.updatePokemonImageFailure,
      isLoading: isLoading ?? this.isLoading,
      imageToShow: imageToShow ?? this.imageToShow,
    );
  }

  @override
  String toString() =>
      'PokemonDetailsState(updatePokemonImageFailure: $updatePokemonImageFailure, isLoading: $isLoading, imageToShow: $imageToShow)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PokemonDetailsState &&
        other.updatePokemonImageFailure == updatePokemonImageFailure &&
        other.isLoading == isLoading &&
        other.imageToShow == imageToShow;
  }

  @override
  int get hashCode => updatePokemonImageFailure.hashCode ^ isLoading.hashCode ^ imageToShow.hashCode;
}

class PokemonDetailsInitial extends PokemonDetailsState {
  const PokemonDetailsInitial()
      : super(
          updatePokemonImageFailure: null,
          isLoading: false,
          imageToShow: '',
        );
}
