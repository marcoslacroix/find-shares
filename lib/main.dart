import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dto/Company.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const CompaniesBuilder({Key? key}) : super(key: key);

  @override
  State<CompaniesBuilder> createState() => _CompaniesBuilderState();
}

class _CompaniesBuilderState extends State<CompaniesBuilder> {
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
        title: Text(AppLocalizations.of(context)!.companies),
      ),
      body: Column(
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
          IconButton(
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
                            leading: const Icon(Icons.business),
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
                                  'Percent More: ${company.percent_more?.toStringAsFixed(2)}%',
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
class FilterModal extends StatefulWidget {
  late Future<List<Company>> companies;
  late List<Company> filteredCompanies;
  final Function(List<Company>) onFilterApplied;


  FilterModal({
    required this.companies,
    required this.filteredCompanies,
    required this.onFilterApplied,
    Key? key,
  }) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late Set<String> _sectors;
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
    _sectors = {};

    fetchSector().then((sectors) {
      setState(() {
        _sectors = sectors.toSet();
      });
    }).catchError((error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filters'),
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text('None'),
              ),
              ..._sectors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ],
            decoration: const InputDecoration(
              labelText: 'Select a sector',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Apply'),
          onPressed: () {
            applyFilter(_selectedFilter, widget.companies);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
            onPressed:() {
              clearFilter(widget.companies);
              Navigator.pop(context);
            },
            child: const Text("Clear")
        ),
      ],
    );
  }

  void clearFilter (Future<List<Company>> companies) {
    companies.then((companyList) {
      List<Company> filteredCompanies;
      setState(() {
        filteredCompanies = widget.filteredCompanies = companyList.toList();
        widget.onFilterApplied(filteredCompanies);
      });
    });
  }

  void applyFilter(String selectedFilter, Future<List<Company>> companies) {
    companies.then((companyList) {
      List<Company> filteredCompanies;
      setState(() {
        if (selectedFilter.isNotEmpty) {
          filteredCompanies = widget.filteredCompanies = companyList
              .where((company) => company.sectorname == selectedFilter)
              .toList();
        } else {
          filteredCompanies = widget.filteredCompanies = companyList.toList();
        }
        widget.onFilterApplied(filteredCompanies);
      });
    });
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

Future<List<String>> fetchSector() async {
  var url = Uri.parse(getSector);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<String> sectors = [];
    for (var item in data) {
      sectors.add(item['sectorname']);
    }
    return sectors;
  } else {
    throw Exception('Failed to fetch sectors');
  }
}

Future<List<Company>> fetchCompanies() async {
  var url = Uri.parse(fetchCompaniesUrl);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    List<dynamic> companiesJsonList = jsonDecode(response.body);
    List<Company> companies =
    companiesJsonList.map((json) => Company.fromJson(json)).toList();
    return companies;
  } else {
    print('Request error. status code: ${response.statusCode}');
    return [];
  }
}
