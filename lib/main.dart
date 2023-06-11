import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dto/Company.dart';
import 'constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CompaniesBuilder(),
    );
  }
}

class CompaniesBuilder extends StatefulWidget {
  const CompaniesBuilder({super.key});

  @override
  State<CompaniesBuilder> createState() => _CompaniesBuilder();
}

class _CompaniesBuilder extends State<CompaniesBuilder> {
  late Future<List<Company>> _companies = Future<List<Company>>.value([]);

  @override
  void initState() {
    super.initState();
    _companies = fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.companies),
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<List<Company>>(
          future: _companies,
          builder: (BuildContext context, AsyncSnapshot<List<Company>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Waiting...'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Erro: ${snapshot.error}'),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              List<Company> companies = snapshot.data!;
              return ListView.builder(
                itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.business),
                        title: Text(companies[index].companyname ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(companies[index].ticker ?? ''),
                            Text('${AppLocalizations.of(context)!.price} ${companies[index].price.toString()}' ?? ''),
                            Text('${AppLocalizations.of(context)!.vi} ${companies[index].vi}' ?? ''),
                            Text('${AppLocalizations.of(context)!.percent_more} ${companies[index].percent_more?.toStringAsFixed(2)}%' ?? ''),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    );
                },
              );
            } else {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('No data available'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Company>> fetchCompanies() async {
  var url = Uri.parse(fetchCompaniesUrl);
  var response = await http.get(url);
  List<Company> companies = [];
  if (response.statusCode == 200) {
    List<dynamic> companiesJsonList = jsonDecode(response.body);
    companies = companiesJsonList.map((json) => Company.fromJson(json)).toList();
  } else {
    print('Request error. status code: ${response.statusCode}');
  }
  return companies;
}
