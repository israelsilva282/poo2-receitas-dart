import 'package:flutter/material.dart';

void main() {
  MyApp app = const MyApp();

  runApp(app);
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
          body: DataBodyWidget(objects: const [
            "La Fin Du Monde - Bock - 65 ibu",
            "Sapporo Premiume - Sour Ale - 54 ibu",
            "Duvel - Pilsner - 82 ibu"
          ]),
          bottomNavigationBar: NewNavBar(
            objects: const [
              Icon(Icons.coffee_outlined),
              Icon(Icons.coffee_outlined),
            ],
          ),
        ));
  }
}

class NewNavBar extends StatelessWidget {
  List<Icon> objects;

  NewNavBar({super.key, this.objects = const []});

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomItems = objects
        .map((obj) => BottomNavigationBarItem(label: "", icon: obj))
        .toList();
    return BottomNavigationBar(onTap: botaoFoiTocado, items: bottomItems);
  }
}

class DataBodyWidget extends StatelessWidget {
  List<String> objects;

  DataBodyWidget({super.key, this.objects = const []});

  Expanded processarUmElemento(String obj) {
    return Expanded(
      child: Center(child: Text(obj)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Expanded> allTheLines = objects
        .map((obj) => Expanded(
              child: Center(child: Text(obj)),
            ))
        .toList();

    return Column(children: allTheLines);
  }
}
