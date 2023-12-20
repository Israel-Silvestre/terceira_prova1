import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../persistencia/pokemon.dart';
import '../database/app_database.dart';

class TelaCaptura extends StatefulWidget {
  final AppDatabase database;

  TelaCaptura({required this.database});

  @override
  _TelaCapturaState createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  List<Pokemon> pokemons = [];
  bool sorteioRealizado = false;

  @override
  void initState() {
    super.initState();
    _sortearPokemons();
  }

  void _sortearPokemons() {
    if (!sorteioRealizado) {
      List<int> idsSorteados = _sortearNumeros();

      List<Future<Pokemon>> futures = [];
      for (var id in idsSorteados) {
        var url = 'https://pokeapi.co/api/v2/pokemon/$id/';
        futures.add(_fetchPokemonData(url));
      }

      Future.wait(futures).then((pokemons) {
        setState(() {
          this.pokemons = pokemons;
          sorteioRealizado = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Captura'),
      ),
      body: FutureBuilder(
        future: _verificarConectividade(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == false) {
            return Center(
              child: Text('Sem conexão com a internet'),
            );
          } else {
            return _buildListView();
          }
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return _buildPokemonItem(pokemons[index]);
      },
    );
  }

  Widget _buildPokemonItem(Pokemon pokemon) {
    return PokemonItemWidget(
      pokemon: pokemon,
      onCapturar: _capturarPokemon,
    );
  }

  Future<bool> _verificarConectividade() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<Pokemon> _fetchPokemonData(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var pokemonData = json.decode(response.body);

      var random = Random();
      var experiencia = random.nextInt(1000);
      var altura = random.nextDouble() * 2.0;

      return Pokemon(
        id: pokemonData['id'],
        url: url,
        nome: pokemonData['name'],
        experiencia: experiencia,
        altura: altura,
        capturado: false,
      );
    } else {
      throw Exception('Erro ao obter dados do Pokémon');
    }
  }

  List<int> _sortearNumeros() {
    var random = Random();
    List<int> idsSorteados = [];

    while (idsSorteados.length < 6) {
      var idSorteado = random.nextInt(50) + 1;
      if (!idsSorteados.contains(idSorteado)) {
        idsSorteados.add(idSorteado);
      }
    }

    return idsSorteados;
  }

  void _capturarPokemon(Pokemon pokemon) async {
    try {
      // Inverte o valor de capturado
      pokemon.capturado = !pokemon.capturado;

      // Atualiza o Pokémon no banco de dados
      await widget.database.pokemonDao.updatePokemon(pokemon);

      setState(() {
        // Atualiza a lista de Pokémons na tela
        pokemons = List.from(pokemons); // Cria uma cópia da lista
      });

      print('${pokemon.nome} foi ${pokemon.capturado ? 'capturado' : 'liberado'}!');
    } catch (e) {
      print('Erro ao atualizar Pokémon no banco de dados: $e');
    }
  }

}

class PokemonItemWidget extends StatefulWidget {
  final Pokemon pokemon;
  final Function(Pokemon) onCapturar;

  PokemonItemWidget({
    required this.pokemon,
    required this.onCapturar,
  });

  @override
  _PokemonItemWidgetState createState() => _PokemonItemWidgetState();
}

class _PokemonItemWidgetState extends State<PokemonItemWidget> {
  @override
  Widget build(BuildContext context) {
    bool capturado = widget.pokemon.capturado;
    Color iconColor = capturado ? Colors.grey : Colors.red;

    return ListTile(
      title: Text(widget.pokemon.nome),
      subtitle: Text('ID: ${widget.pokemon.id}'),
      trailing: IconButton(
        icon: Stack(
          children: [
            Icon(Icons.brightness_1, color: iconColor),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 1.5,
                  width: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        onPressed: capturado ? null : () => widget.onCapturar(widget.pokemon),
        color: Colors.transparent,
      ),
    );
  }
}
