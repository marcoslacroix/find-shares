import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../auth/auth.dart';
import '../dto/Company.dart';
import '../util/constants.dart';

class BrazilSharePage extends StatefulWidget {
  const BrazilSharePage({Key? key}) : super(key: key);

  @override
  State<BrazilSharePage> createState() => _BrazilSharePageState();

}

class _BrazilSharePageState extends State<BrazilSharePage> {
  late Future<List<Company>> _companies;
  List<Company> filteredCompanies = [];
  late Set<String> _sectors = {};
  String _selectedFilter = '';
  late final auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<Auth>(context, listen: false);
    fetchSector(auth).then((sectors) {
      setState(() {
        _sectors = sectors.toSet();
      });
    }).catchError((error) {
      // Handle error
    });

    _companies = fetchCompanies(auth);

    _companies.then((companies) {
      setState(() {
        filteredCompanies = companies.toList();
      });
    });
  }

  void applyFilterSector() {
    _companies.then((companyList) {
      setState(() {
        if (_selectedFilter.isNotEmpty) {
          filteredCompanies = filteredCompanies = companyList
              .where((company) => company.sectorname == _selectedFilter)
              .toList();
        } else {
          filteredCompanies = filteredCompanies = companyList.toList();
        }
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
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                        applyFilterSector();
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
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ],
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
                    return Container(
                      width: 10,
                      height: 10,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
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
                          margin: const EdgeInsets.only(top: 16),
                          child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(company.companyname ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(company.ticker ?? ''),
                                Row(
                                  children: [
                                    Text(
                                      'Price: R\$ ${company.price.toString() ?? ''}',
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'VI: R\$ ${company.vi?.toStringAsFixed(2) ?? ''}',
                                    ),
                                  ],
                                ),
                                Text(
                                  'Earning Yield: ${company.earningYield?.toStringAsFixed(2)?? '0'}%',
                                ),
                                Text('Sector: ${company.sectorname ?? ''}'),
                                Text('Segment: ${company.segmentname ?? ''}'),
                                Text('Subsector: ${company.subsectorname ?? ''}'),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  company.favorite = !isFavorite;
                                });
                                updateStatus(
                                    company.ticker.toString(),
                                    !isFavorite,
                                    auth
                                );
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

Future<void> updateStatus(String ticker, bool status, Auth auth) async {
  var url = Uri.parse(updateFavoriteUrl).replace(
    queryParameters: {
      'ticker': ticker,
      'favorite': status.toString(),
    },
  );
  await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: auth.token,
      }
  );
}

Future<List<String>> fetchSector(Auth auth) async {
  var url = Uri.parse(getSector);
  var response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: auth.token,
      }
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<String> sectors = [];
    for (var item in data) {
      sectors.add(item['sectorname']);
    }
    return sectors;
  }
  return [];
}

Future<List<Company>> fetchCompanies(Auth auth) async {
  var url = Uri.parse(fetchCompaniesUrl);

  var response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: auth.token,
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

