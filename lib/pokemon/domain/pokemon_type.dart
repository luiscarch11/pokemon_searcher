enum PokemonType {
  normal,
  fighting,
  flying,
  poison,
  ground,
  rock,
  bug,
  ghost,
  steel,
  fire,
  water,
  grass,
  electric,
  psychic,
  ice,
  dragon,
  dark,
  fairy,
  unknown,
  shadow;

  String get iconName {
    switch (this) {
      case PokemonType.normal:
        return 'normal';
      case PokemonType.fighting:
        return 'lucha';
      case PokemonType.flying:
        return 'volador';
      case PokemonType.poison:
        return 'veneno';
      case PokemonType.ground:
        return 'tierra';
      case PokemonType.rock:
        return 'roca';
      case PokemonType.bug:
        return 'bicho';
      case PokemonType.ghost:
        return 'fantasma';
      case PokemonType.steel:
        return 'acero';
      case PokemonType.fire:
        return 'fuego';
      case PokemonType.water:
        return 'agua';
      case PokemonType.grass:
        return 'planta';
      case PokemonType.electric:
        return 'electrico';
      case PokemonType.psychic:
        return 'psiquico';
      case PokemonType.ice:
        return 'hielo';
      case PokemonType.dragon:
        return 'dragon';
      case PokemonType.dark:
        return 'siniestro';
      case PokemonType.fairy:
        return 'hada';
      case PokemonType.unknown:
        return '';
      case PokemonType.shadow:
        return '';
    }
  }

  static PokemonType fromString(String type) {
    switch (type) {
      case 'normal':
        return PokemonType.normal;
      case 'fighting':
        return PokemonType.fighting;
      case 'flying':
        return PokemonType.flying;
      case 'poison':
        return PokemonType.poison;
      case 'ground':
        return PokemonType.ground;
      case 'rock':
        return PokemonType.rock;
      case 'bug':
        return PokemonType.bug;
      case 'ghost':
        return PokemonType.ghost;
      case 'steel':
        return PokemonType.steel;
      case 'fire':
        return PokemonType.fire;
      case 'water':
        return PokemonType.water;
      case 'grass':
        return PokemonType.grass;
      case 'electric':
        return PokemonType.electric;
      case 'psychic':
        return PokemonType.psychic;
      case 'ice':
        return PokemonType.ice;
      case 'dragon':
        return PokemonType.dragon;
      case 'dark':
        return PokemonType.dark;
      case 'fairy':
        return PokemonType.fairy;
      case 'unknown':
        return PokemonType.unknown;
      case 'shadow':
        return PokemonType.shadow;
      default:
        return PokemonType.unknown;
    }
  }
}
