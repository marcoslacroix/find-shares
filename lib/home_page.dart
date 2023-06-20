import 'package:find_shares/real_estate_funds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'american_shares.dart';
import 'auth.dart';
import 'company_historic.dart';
import 'brazil_share.dart';
import 'info_strategy.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    print("Auth ${auth}");
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
                    MaterialPageRoute(builder: (context) => const BrazilShare())
                );
              },
            ),
            ListTile(
              title: const Text('Fundos imobiliarios'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RealStateFunds())
                );
              },
            ),
            ListTile(
              title: const Text('Ações bolsa americana'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AmericanShares())
                );
              },
            ),
            ListTile(
              title: const Text('Conferir Ações/FIIS que devem ser vendidas'),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoStrategy())
                );
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