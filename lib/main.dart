import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService with ChangeNotifier {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

  List<String> getColumNames() {
    final value = tableStateNotifier.value;
    if (value.isEmpty) {
      return [];
    } else if (value[0].containsKey('origem')) {
      return ['Nome', 'Origem', 'Intensidade'];
    } else if (value[0].containsKey('style')) {
      return ['Nome', 'Estilo', 'IBU'];
    } else if (value[0].containsKey('continente')) {
      return ['Nome', 'Continente', 'População'];
    } else {
      return [];
    }
  }

  List<String> getPropertyNames() {
    final value = tableStateNotifier.value;
    if (value.isEmpty) {
      return [];
    } else if (value[0].containsKey('origem')) {
      return ['name', 'origem', 'intensidade'];
    } else if (value[0].containsKey('style')) {
      return ['name', 'style', 'ibu'];
    } else if (value[0].containsKey('continente')) {
      return ['name', 'continente', 'populacao'];
    } else {
      return [];
    }
  }

  void carregar(int index) {
    if (index == 0) {
      carregarCafes();
    } else if (index == 1) {
      carregarCervejas();
    } else if (index == 2) {
      carregarNacoes();
    }
  }

  void carregarCafes() {
    tableStateNotifier.value = [
      {"name": "Café 1", "origem": "Brasil", "intensidade": "Forte"},
      {"name": "Café 2", "origem": "Colômbia", "intensidade": "Média"},
      {"name": "Café 3", "origem": "Etiópia", "intensidade": "Suave"}
    ];
    notifyListeners();
  }

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "Cerveja 1", "style": "IPA", "ibu": "60"},
      {"name": "Cerveja 2", "style": "Stout", "ibu": "40"},
      {"name": "Cerveja 3", "style": "Pilsner", "ibu": "25"}
    ];
    notifyListeners();
  }

  void carregarNacoes() {
    tableStateNotifier.value = [
      {"name": "País 1", "continente": "América", "populacao": "100 milhões"},
      {"name": "País 2", "continente": "Europa", "populacao": "50 milhões"},
      {"name": "País 3", "continente": "Ásia", "populacao": "200 milhões"}
    ];
    notifyListeners();
  }
}

final dataService = DataService();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dicas"),
        ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            return DataTableWidget(
              jsonObjects: value,
              columnNames: dataService.getColumNames(),
              propertyNames: dataService.getPropertyNames(),
            );
          },
        ),
        bottomNavigationBar:
            NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  final Function(int) itemSelectedCallback;

  const NewNavBar({super.key, required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(0);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        itemSelectedCallback(index);
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

  const DataTableWidget({
    super.key,
    this.jsonObjects = const [],
    this.columnNames = const ["Nome", "Estilo", "IBU"],
    this.propertyNames = const ["name", "style", "ibu"],
  });

  @override
  Widget build(BuildContext context) {
    if (columnNames.isEmpty) {
      // Exibe uma mensagem ou widget alternativo quando não há colunas
      return const Center(
        child: Text(
          'Nenhum dado disponível.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return DataTable(
      columns: columnNames
          .map(
            (name) => DataColumn(
              label: Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          )
          .toList(),
      rows: jsonObjects
          .map(
            (obj) => DataRow(
              cells: propertyNames
                  .map(
                    (propName) => DataCell(
                      Text(obj[propName]),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
