class StringConstants {
  static const _pokemonImage = 'https://www.pkparaiso.com/imagenes/pokedex/pokemon/';
  static const _pokemonTypeImage = 'https://www.pkparaiso.com/imagenes/xy/sprites/tipos/';
  static String pokemonImage(int id) {
    String idString = id.toString();
    String zerosToAdd = '';
    for (int i = 0; i < 3 - idString.length; i++) {
      zerosToAdd += '0';
    }
    idString = zerosToAdd + idString;
    return '$_pokemonImage$idString.png';
  }

  static const loadingAsset = 'assets/loading.gif';
  static const getPokemonsEndpointUrl = 'https://pokeapi.co/api/v2/pokemon/';
  static String getPokemonsWithFilterEndpointUrl(String pokemonName) =>
      'https://pokeapi.co/api/v2/pokemon/$pokemonName';

  static String pokemonTypeImage(String type) {
    return '$_pokemonTypeImage$type.gif';
  }
}
