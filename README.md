# Pokemon searcher

This app is intended to be a searcher of Pokemons and some of their basic data.
For getting it, I used [PokeApi](https://pokeapi.co/) as my origin.
Also, I used [PKParaiso](https://www.pkparaiso.com) for getting pokemons' images.

The state management tool used for this project was [Flutter BLoC](https://pub.dev/packages/flutter_bloc); HTTP calls were made using regular [HTTP package](https://pub.dev/packages/http); images were gotten using [Image Picker package](https://pub.dev/packages/image_picker) and the tool used for caching data was [Shared Preferences package](https://pub.dev/packages/shared_preferences).

The architecture of the app itself follows Clean Architecture guidelines, separating the code into 4 different layers:

 1. Presentation: all of the code used to show UI to the user and interact with them
 2. Application: the application logics, handling events performed by the user and intermediating between him and the services behind the data
 3. Domain: business logics and models. Core concepts, definitions and known rules are stored here
 4. Infrastructure: here, I handle all of the calls to third party services, as well as the handling of json (from and to) objects and transforming them into something my app know how to work with.

Unit tests were made by using [Mocktail](https://pub.dev/packages/mocktail) for mocking dependencies, and [Bloc Test](https://pub.dev/packages/bloc_test) for helping me get Cubits tests done quickly.


Flutter version: 3.10.1
Dart version: 3.0.1