import 'package:flutter/material.dart';
import 'dto/Company.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'util/constants.dart';

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
            onPressed:() {
              clearFilter(widget.companies);
              Navigator.pop(context);
            },
            child: const Text("Clear")
        ),
        ElevatedButton(
          child: const Text('Apply'),
          onPressed: () {
            applyFilter(_selectedFilter, widget.companies);
            Navigator.pop(context);
          },
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
