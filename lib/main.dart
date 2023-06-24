import 'package:find_shares/auth/token_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: const MaterialApp(
        //localizationsDelegates: AppLocalizations.localizationsDelegates,
        //supportedLocales: AppLocalizations.supportedLocales,
        home: TokenChecker()
      ),
    );
  }
}
