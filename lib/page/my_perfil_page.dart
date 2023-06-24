import 'package:find_shares/button/logout_button.dart';
import 'package:flutter/material.dart';

import '../button/delete_account_button.dart';

class MyPerfilPage extends StatefulWidget {
  const MyPerfilPage({super.key});

  @override
  _MyPerfilPage createState() => _MyPerfilPage();
}

class _MyPerfilPage extends State<MyPerfilPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person_2),
              // todo obter nome do usuário
              Text("Nome do usuário")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DeleteAccountButton()
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoutButton()
            ],
          ),
        ],
      ),
    );
  }

}
