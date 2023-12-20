import 'package:flutter/material.dart';
import 'package:terceira_prova/database/app_database.dart';
import 'package:terceira_prova/persistencia/pokemon.dart';
import 'tela_detalhes_pokemon.dart';
import 'tela_soltar_pokemon.dart';

class TelaPokemonCapturado extends StatelessWidget {
  final AppDatabase database;

  TelaPokemonCapturado({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémons Capturados'),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: database.pokemonDao.findAllPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Erro ao carregar Pokémons'),
            );
          } else {
            List<Pokemon> pokemons = snapshot.data!;
            return _buildListView(context, pokemons);
          }
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Pokemon> pokemons) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        Pokemon pokemon = pokemons[index];

        return GestureDetector(
          onTap: () => _navigateToDetalhesPokemon(context, pokemon),
          onLongPress: () => _navigateToSoltarPokemon(context, pokemon.id),
          child: ListTile(
            title: Text(pokemon.nome),
            subtitle: Text('ID: ${pokemon.id}'),
            trailing: Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }

  void _navigateToDetalhesPokemon(BuildContext context, Pokemon pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesPokemon(pokemon: pokemon),
      ),
    );
  }

  void _navigateToSoltarPokemon(BuildContext context, int pokemonId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaSoltarPokemon(pokemonId: pokemonId, database: database),
      ),
    );
  }
}
