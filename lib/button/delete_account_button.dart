import 'package:find_shares/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return TextButton(
      child: const Text("Deletar"),
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.red)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmação"),
              content: const Text("Deseja deletar PERNAMENTE sua conta?"),
              actions: [
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Confirmar"),
                  onPressed: () {
                    auth.logout();
                    // todo deletar account
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
                ),
              ],
            );
          },
        );
      },
    );

  }
}