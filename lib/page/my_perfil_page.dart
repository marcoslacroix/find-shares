import 'dart:convert';
import 'dart:io';
import 'package:find_shares/button/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../auth/auth.dart';
import '../button/delete_account_button.dart';
import '../dto/User.dart';
import '../util/constants.dart';

class MyPerfilPage extends StatefulWidget {
  const MyPerfilPage({super.key});

  @override
  _MyPerfilPage createState() => _MyPerfilPage();
}

class _MyPerfilPage extends State<MyPerfilPage> {

  late final auth = Provider.of<Auth>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<User>(
                future: fetchUser(auth),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final user = snapshot.data;
                    final userName = user?.name ?? '';
                    final userLastName = user?.lastname ?? '';
                    return Text('$userName $userLastName');
                  }
                },
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DeleteAccountButton()
            ],
          ),
          const Row(
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

Future<User> fetchUser(Auth auth) async {
  var url = Uri.parse(getUser);
  var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: auth.token,
      }
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return User.fromJson(data);
  } else {
    throw Exception('Failed to fetch user');
  }

}
