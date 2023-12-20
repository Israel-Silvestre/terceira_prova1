import 'package:flutter/material.dart';
import '../persistencia/pokemon.dart';

class TelaDetalhesPokemon extends StatelessWidget {
  final Pokemon pokemon;

  TelaDetalhesPokemon({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${pokemon.id}'),
            Text('Nome: ${pokemon.nome}'),
            Text('Experiência: ${pokemon.experiencia}'),
            Text('Altura: ${pokemon.altura} m'),
            Text('Capturado: ${pokemon.capturado ? 'Sim' : 'Não'}'),
          ],
        ),
      ),
    );
  }
}
