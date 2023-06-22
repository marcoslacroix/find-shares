import 'package:find_shares/button/logout_button.dart';
import 'package:find_shares/page/real_estate_funds_page.dart';
import 'package:find_shares/page/wallet_exemples_page.dart';
import 'package:flutter/material.dart';
import 'american_shares_page.dart';
import 'company_historic_page.dart';
import 'brazil_share_page.dart';
import 'info_strategy_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina inicial"),
        actions: const <Widget>[
          LogoutButton(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 55,
              alignment: Alignment.center,
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
              leading: const Icon(Icons.flag),
              title: const Text('Ações do Brasil'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BrazilSharePage())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.broken_image_outlined),
              title: const Text('Fundos imobiliarios'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RealStateFundsPage())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.accessibility_sharp),
              title: const Text('Ações bolsa americana'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AmericanSharesPage())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Conferir Ações/FIIS que devem ser vendidas'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompanyHistoricPage())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cabin_rounded),
              title: const Text('Como funciona minha estratégia'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoStrategyPage())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Exemplos de carteiras'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WalletExemplesPage())
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