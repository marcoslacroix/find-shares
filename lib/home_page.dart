import 'package:flutter/material.dart';
import 'company_historic.dart';
import 'brazil_share.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Ações do Brasil'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BrazilShare())
                );
              },
            ),
            ListTile(
              title: const Text('Fundos imobiliarios'),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Ações bolsa americana'),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text('Conferir Ações/FIIS que devem ser vendidos'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompanyHistoric())
                );
              },
            ),
            ListTile(
              title: const Text('Como funciona minha estratégia'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: const Card(
        child: Text("Bem vindo"),
      ),
    );
  }
}