import 'package:flutter/material.dart';

class AmericanSharesPage extends StatefulWidget {
  const AmericanSharesPage({super.key});

  @override
  _AmericanShares createState() => _AmericanShares();
}

class _AmericanShares extends State<AmericanSharesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ações Internacionais"),
      ),
      body: Container(
        // Widget do corpo da tela
      ),
    );
  }
}
