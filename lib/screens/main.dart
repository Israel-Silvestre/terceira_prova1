// main.dart
import 'package:flutter/material.dart';
import 'package:terceira_prova/database/app_database.dart';
import 'tela_captura.dart';
import 'tela_pokemon_capturado.dart';
import 'tela_sobre.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialize o banco de dados Floor
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaHome(database),
    );
  }
}

class TelaHome extends StatelessWidget {
  final AppDatabase database;

  const TelaHome(this.database);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          title: Text('terceira_prova'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Início'),
              Tab(text: 'Captura'),
              Tab(text: 'Capturados'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Navegar para a TelaSobre
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaSobre(),
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Conteúdo da aba "Início"
            Center(
              child: Text(
                'este app é uma pokedex para administrar seu acervo de pokemons.',
                style: TextStyle(fontSize: 20),
              ),
            ),
            // Conteúdo da aba "Captura"
            TelaCaptura(database: database),
            // Conteúdo da aba "Capturados"
            TelaPokemonCapturado(database: database),
          ],
        ),
      ),
    );
  }
}

