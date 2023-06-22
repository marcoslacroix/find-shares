import 'package:flutter/material.dart';

class CompanyHistoricPage extends StatefulWidget {
  const CompanyHistoricPage({super.key});


  @override
  _CompanyHistoricPageState createState() => _CompanyHistoricPageState();
}

class _CompanyHistoricPageState extends State<CompanyHistoricPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Empresas que devem ser vendidas"),
      ),
      body: Container(
        // Widget do corpo da tela
      ),
    );
  }
}