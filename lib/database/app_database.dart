import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:terceira_prova/persistencia/pokemon.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Pokemon])
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}


