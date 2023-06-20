import 'package:flutter/material.dart';

class InfoStrategy extends StatefulWidget {
  const InfoStrategy({super.key});

  @override
  _InfoStrategy createState() => _InfoStrategy();
}

class _InfoStrategy extends State<InfoStrategy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Como funciona minha estratégia"),
      ),
      body: Container(
        // Widget do corpo da tela
      ),
    );
  }

}
