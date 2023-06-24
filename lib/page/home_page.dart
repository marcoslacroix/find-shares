import 'package:find_shares/button/logout_button.dart';
import 'package:find_shares/page/real_estate_funds_page.dart';
import 'package:find_shares/page/wallet_exemples_page.dart';
import 'package:flutter/material.dart';
import 'american_shares_page.dart';
import 'company_historic_page.dart';
import 'brazil_share_page.dart';
import 'info_strategy_page.dart';
import 'my_perfil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}


class _HomePage extends State<HomePage> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          Center(
            child: Text('Conteúdo da tela Início'),
          ),
          Center(
            child: BrazilSharePage(),
          ),
          Center(
            child: MyPerfilPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Ações do Brasil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}