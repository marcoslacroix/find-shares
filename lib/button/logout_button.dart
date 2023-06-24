import 'package:find_shares/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return TextButton(
      child: const Text("Logout"),
      onPressed: () {
        auth.logout();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Usuário desconectado'),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
            fullscreenDialog: true,
          ),
          (route) => false,
        );
      },
    );
  }
}