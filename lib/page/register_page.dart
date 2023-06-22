import 'package:find_shares/page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _passwordController;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email obrigatório'),
        ),
      );
    } else if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Nome obrigatório'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cadastro")
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(
                labelText: 'Sobrenome',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: !isPasswordVisible,
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.00),
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => _handleRegister(context),
                    child: const Text('Enviar'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.00),
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage(),
                          fullscreenDialog: true
                      ),
                      (route) => false
                  )},
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
