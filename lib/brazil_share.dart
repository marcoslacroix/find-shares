import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'filter_modal.dart';
import 'dto/Company.dart';
import 'package:intl/intl.dart';
import 'util/constants.dart';

class BrazilShare extends StatefulWidget {
  const BrazilShare({Key? key}) : super(key: key);

  @override
  State<BrazilShare> createState() => _BrazilShareState();
}

class _BrazilShareState extends State<BrazilShare> {
  late Future<List<Company>> _companies;
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
        title: const Text("Ações Brasileiras"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterNames,
              decoration: const InputDecoration(
                labelText: "Pesquisar",
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FilterModal(
                      companies: _companies,
                      filteredCompanies: filteredCompanies,
                      onFilterApplied: (List<Company> filteredCompanies) {
                        setState(() {
                          this.filteredCompanies = filteredCompanies;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!,
              textAlign: TextAlign.center,
              child: FutureBuilder<List<Company>>(
                future: _companies,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Company>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: filteredCompanies.length,
                      itemBuilder: (context, index) {
                        Company company = filteredCompanies[index];
                        bool isFavorite = company.favorite ?? false;
                        Locale deviceLocale = WidgetsBinding.instance!.window.locale;
                        return Card(
                          child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(company.companyname ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(company.ticker ?? ''),
                                Text(
                                    'Valor de mercado: ${NumberFormat.currency(locale: deviceLocale.toString() , symbol: '\$').format(company.valormercado ?? 0)}'
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Price: R\$ ${company.price.toString()}',
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'VI: R\$ ${company.vi?.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                                Text(
                                  'Dividend Yield: ${company.dy?.toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Earning Yield: ${company.earningYield?.toStringAsFixed(2)}%',
                                ),
                                Text('Sector: ${company.sectorname}'),
                                Text('Segment: ${company.segmentname}'),
                                Text('Subsector: ${company.subsectorname}'),
                                Text('Tag Along: ${company.tagAlong}'),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  company.favorite = !isFavorite;
                                });
                                updateStatus(company.ticker.toString(),
                                    !isFavorite);
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No data available');
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
      'favorite': status.toString(),
    },
  );
  await http.post(url);
}


Future<List<Company>> fetchCompanies() async {
  var url = Uri.parse(fetchCompaniesUrl);

  var response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImEiLCJpYXQiOjE2ODcxMjk3MzV9.xbmxnoyMbTLI7wBaHVWtw6uJ82-40_Z3tJquIN-QtM0',
    }
  );
  if (response.statusCode == 200) {
    List<dynamic> companiesJsonList = jsonDecode(response.body);
    List<Company> companies = companiesJsonList.map((json) => Company.fromJson(json)).toList();
    return companies;
  } else {
    print('Request error. status code: ${response.statusCode}');
    return [];
  }
}

