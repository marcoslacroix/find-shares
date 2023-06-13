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
  List<Company> filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _companies = fetchCompanies();
    _companies.then((companies) {
      setState(() {
        filteredCompanies = companies.toList();
      });
    });
  }

  void filterNames(String keyword) {
    _companies.then((companies) {
      setState(() {
        filteredCompanies = companies
            .where((company) =>
              company.companyname!
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
              .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.companies),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterNames,
              decoration: const InputDecoration(
                labelText: 'Digite um nome' // todo utilizar AppLocations
              ),
            ),
          ),
          Expanded(
            child: DefaultTextStyle(
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
                          child: Text('Waiting...'), // todo Utilizar Applocations
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
                          child: Text('Erro: ${snapshot.error}'), // todo Utilizar Applocations
                        ),
                      ],
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) {
                          Company company = filteredCompanies[index];
                          bool isFavorite = company.favorite ?? false;
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.business),
                              title: Text(company.companyname ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(company.ticker ?? ''),
                                  Row(
                                    children: [
                                      Text('${AppLocalizations.of(context)!.price}: R\$ ${company.price.toString()}'),
                                      const SizedBox(width: 10), // Add some spacing between the attributes
                                      Text('${AppLocalizations.of(context)!.vi}: R\$ ${company.vi?.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  Text('${AppLocalizations.of(context)!.dividendYield}: ${company.dy?.toStringAsFixed(2)}'),
                                  Text('${AppLocalizations.of(context)!.percentMore}: ${company.percent_more?.toStringAsFixed(2)}%'),
                                  Text('${AppLocalizations.of(context)!.sector}: ${company.sectorname}'),
                                  Text('${AppLocalizations.of(context)!.segment}: ${company.segmentname}'),
                                  Text('${AppLocalizations.of(context)!.subSector}: ${company.subsectorname}'),
                                  Text('${AppLocalizations.of(context)!.tagAlong}: ${company.tagAlong}')
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    company.favorite = !isFavorite;
                                  });
                                  updateStatus(company.ticker.toString(), !isFavorite);
                                  // Handle icon tap event
                                  // Add your logic here to update the favorite status
                                },
                                icon: isFavorite
                                    ? const Icon(Icons.favorite,
                                    color: Colors.red)
                                    : const Icon(Icons.favorite_border)
                                ),
                            )
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
                          child: Text('No data available'), // todo Utilizar Applocations
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateStatus(String ticker, bool status) async {

  var url = Uri.parse(updateFavoriteUrl).replace(
    queryParameters: {
      'ticker': ticker,
      'favorite': status.toString()
    }
  );
  await http.post(url);
}

Future<List<Company>> fetchCompanies() async {
  var url = Uri.parse(fetchCompaniesUrl);
  var response = await http.get(url);
  List<Company> companies = [];
  if (response.statusCode == 200) {
    List<dynamic> companiesJsonList = jsonDecode(response.body);
    companies = companiesJsonList.map((json) => Company.fromJson(json)).toList();
  } else {
    print('Request error. status code: ${response.statusCode}'); // todo Utilizar Applocations
  }
  return companies;
}
