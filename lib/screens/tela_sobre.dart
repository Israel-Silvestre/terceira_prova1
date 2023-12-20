import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre o Aplicativo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'desenvolvedores: Tiago de Melo e Israel Silvestre.',
              style: TextStyle(fontSize: 20),
            ),
            // Adicione mais informações sobre os desenvolvedores, se necessário.
          ],
        ),
      ),
    );
  }
}
