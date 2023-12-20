import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../persistencia/pokemon.dart';

class TelaSoltarPokemon extends StatelessWidget {
  final int pokemonId;
  final AppDatabase database;

  TelaSoltarPokemon({required this.pokemonId, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soltar Pokémon'),
      ),
      body: FutureBuilder<Pokemon?>(
        future: database.pokemonDao.findPokemonById(pokemonId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Erro ao carregar dados do Pokémon'),
            );
          } else {
            Pokemon pokemon = snapshot.data!;

            return _buildPokemonDetails(context, pokemon);
          }
        },
      ),
    );
  }

  Widget _buildPokemonDetails(BuildContext context, Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text('ID: ${pokemon.id}'),
          Text('Nome: ${pokemon.nome}'),
          Text('Experiência: ${pokemon.experiencia}'),
          Text('Altura: ${pokemon.altura}'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _confirmarSoltarPokemon(context, pokemon),
                child: Text('Confirmar'),
              ),
              ElevatedButton(
                onPressed: () => _cancelarSoltarPokemon(context),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarSoltarPokemon(BuildContext context, Pokemon pokemon) async {
    try {
      // Remover o Pokémon do banco de dados
      await database.pokemonDao.deletePokemon(pokemon);

      // Navegar de volta para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao soltar Pokémon: $e');
    }
  }

  void _cancelarSoltarPokemon(BuildContext context) {
    // Navegar de volta para a tela anterior sem realizar nenhuma ação
    Navigator.pop(context);
  }
}
