import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

enum TableStatus { idle, loading, ready, error }

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
      ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(index) {
    final funcoes = [carregarCafes, carregarCervejas, carregarNacoes];

    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'propertyNames': [],
      'columnNames': [],
    };

    funcoes[index]();
  }

  void carregarCafes() {
    var cafesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/coffee/random_coffee',
        queryParameters: {'size': '5'});

    http.get(cafesUri).then((response) {
      if (response.statusCode == 200) {
        var cafesJson = jsonDecode(response.body);

        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': cafesJson,
          'propertyNames': [
            "blend_name",
            "origin",
            "variety",
            "notes",
            "intensifier"
          ],
          'columnNames': [
            "Blend Name",
            "Origin",
            "Variety",
            "Notes",
            "Intensifier"
          ],
        };
      } else {
        tableStateNotifier.value = {
          'status': TableStatus.error,
          'dataObjects': [],
          'propertyNames': [],
          'columnNames': [],
        };
      }
    });
  }

  void carregarNacoes() async {
    var nacoesUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/nation/random_nation',
        queryParameters: {'size': '5'});

    try {
      var response = await http.get(nacoesUri);
      if (response.statusCode == 200) {
        var nacoesJson = jsonDecode(response.body);

        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': nacoesJson,
          'propertyNames': [
            "nationality",
            "language",
            "capital",
            "national_sport"
          ],
          'columnNames': [
            "Nationality",
            "Language",
            "Capital",
            "National Sport"
          ],
        };
      } else {
        tableStateNotifier.value = {
          'status': TableStatus.error,
          'dataObjects': [],
          'propertyNames': [],
          'columnNames': [],
        };
      }
    } catch (e) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
        'dataObjects': [],
        'propertyNames': [],
        'columnNames': [],
      };
    }
  }

  void carregarCervejas() {
    var cervejasUri = Uri(
        scheme: 'https',
        host: 'random-data-api.com',
        path: 'api/v2/beers',
        queryParameters: {});

    http.get(cervejasUri).then((response) {
      if (response.statusCode == 200) {
        var cervejasJson = jsonDecode(response.body);

        tableStateNotifier.value = {
          'status': TableStatus.ready,
          'dataObjects': cervejasJson,
          'propertyNames': [
            "brand",
            "name",
            "style",
            "hop",
            "yeast",
            "malts",
            "ibu",
            "alcohol",
            "blg"
          ],
          'columnNames': [
            "Brand",
            "Name",
            "Style",
            "Hop",
            "Yeast",
            "Malts",
            "IBU",
            "Alcohol",
            "BLG"
          ],
        };
      } else {
        tableStateNotifier.value = {
          'status': TableStatus.error,
          'dataObjects': [],
          'propertyNames': [],
          'columnNames': [],
        };
      }
    });
  }
}

void main() {
  runApp(AppDicas());
}

class AppDicas extends StatelessWidget {
  final dataService = DataService();

  AppDicas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Dicas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(dataService: dataService),
    );
  }
}

class HomeScreen extends HookWidget {
  final DataService dataService;

  const HomeScreen({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      dataService.carregar(0);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Dicas"),
      ),
      body: ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: dataService.tableStateNotifier,
        builder: (context, value, child) {
          switch (value['status']) {
            case TableStatus.idle:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bem-vindo(a) ao App Dicas!",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Toque em um dos botões abaixo para carregar os dados:",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );

            case TableStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case TableStatus.ready:
              return DataTableWidget(
                jsonObjects: value['dataObjects'],
                propertyNames: value['propertyNames'],
                columnNames: value['columnNames'],
              );

            case TableStatus.error:
              return const Center(
                child: Text(
                  "Ocorreu um erro ao carregar os dados.",
                  style: TextStyle(fontSize: 16),
                ),
              );
          }

          return const Text("...");
        },
      ),
      bottomNavigationBar:
          NewNavBar(itemSelectedCallback: dataService.carregar),
    );
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  NewNavBar({super.key, itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? (int);

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas",
          icon: Icon(Icons.local_drink_outlined),
        ),
        BottomNavigationBarItem(
          label: "Nações",
          icon: Icon(Icons.flag_outlined),
        ),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  const DataTableWidget(
      {super.key,
      required this.jsonObjects,
      required this.columnNames,
      required this.propertyNames});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columnNames.map<DataColumn>((columnName) {
              return DataColumn(label: Text(columnName));
            }).toList(),
            rows: jsonObjects.map<DataRow>((jsonObject) {
              return DataRow(
                  cells: propertyNames.map<DataCell>((propertyName) {
                return DataCell(Text(jsonObject[propertyName].toString()));
              }).toList());
            }).toList(),
          ),
        ),
      ],
    );
  }
}
