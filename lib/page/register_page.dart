import 'dart:convert';
import 'dart:io';
import 'package:find_shares/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../util/constants.dart';


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
  bool passwordContainsNumber = false;
  bool passwordContainsUppercase = false;
  bool passwordContainsLowercase = false;
  bool passwordContainsSpecialChar = false;
  bool passwordContainsEigthToTwelveDigits = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordController.addListener(updatePasswordContainsNumberAndUppercase);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _passwordController.removeListener(updatePasswordContainsNumberAndUppercase);
    super.dispose();
  }

  void updatePasswordContainsNumberAndUppercase() {
    setState(() {
      String password = _passwordController.text;
      passwordContainsNumber = password.contains(RegExp(r'[0-9]'));
      passwordContainsLowercase = password.contains(RegExp(r'[a-z]'));
      passwordContainsSpecialChar = password.contains(RegExp(r'[^A-Za-z0-9]'));
      passwordContainsUppercase = password.contains(RegExp(r'[A-Z]'));
      passwordContainsEigthToTwelveDigits = password.length >= 8 && password.length <= 12;
    });
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
            Row(
              children: [
                if (passwordContainsUppercase)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                else
                  const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                Text(
                  'Letra maiúscula',
                  style: TextStyle(
                    color: passwordContainsUppercase ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Row(
                children: [
                  if (passwordContainsNumber)
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  else
                    const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  Text(
                    'Número',
                    style: TextStyle(
                      color: passwordContainsNumber ? Colors.green : Colors.red,
                    ),
                  ),
                ],
            ),
            Row(
              children: [
                if (passwordContainsLowercase)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                else
                  const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                Text(
                  'Letra minuscula',
                  style: TextStyle(
                    color: passwordContainsLowercase ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (passwordContainsSpecialChar)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                else
                  const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                Text(
                  'Character especial',
                  style: TextStyle(
                    color: passwordContainsSpecialChar ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (passwordContainsEigthToTwelveDigits)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                else
                  const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                Text(
                  'A senha contém de 8 a 12 caracteres',
                  style: TextStyle(
                    color: passwordContainsEigthToTwelveDigits ? Colors.green : Colors.red,
                  ),
                ),
              ],
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

  bool validateFields() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email obrigatório'),
        ),
      );
      return false;
    } else if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Nome obrigatório'),
        ),
      );
      return false;
    } else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Password obrigatório"),
        ),
      );
      return false;
    } else if (_lastnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Sobrenome obrigatório"),
        ),
      );
      return false;
    } else if (!isPasswordStrong(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Senha deve conter pelo menos 8 caracteres, incluindo letras maiúsculas, minúsculas e números."),
        ),
      );
      return false;
    }

    return true;
  }

  bool isPasswordStrong(String password) {
    if (password.length < 8) {
      return false;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }


  Future<Response> doRegister() async {
    Map<String, dynamic> payload = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "name": _nameController.text,
      "lastName": _lastnameController.text
    };
    String jsonPayload = jsonEncode(payload);
    var url = Uri.parse(createUserUrl);
    var response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonPayload
    );
    return response;
  }

  void _handleRegister(BuildContext context) {
    if (validateFields()) {
      Future<Response> futureResponse = doRegister();

      futureResponse.then((response) => {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Registro efetuado com sucesso'),
            ),
          ),
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage(),
                fullscreenDialog: true,
              ),
                  (route) => false
          )
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(jsonDecode(response.body)["message"] ?? "Houve um error"),
            ),
          )
        }
      });
    }
  }

}

