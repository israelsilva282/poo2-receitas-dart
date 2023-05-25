import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Primeiro App',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: Scaffold(
          appBar: AppBar(title: const Text("Meu app")),
          body: const Center(
              child: Column(children: [
            Text(
              "Apenas começando...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("No meio..."),
            Text("Terminando...")
          ])),
          bottomNavigationBar: BottomNavigationBar(items: const [
            BottomNavigationBarItem(
                label: "Favorito", icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(label: "Fechar", icon: Icon(Icons.close))
          ]),
        ));
  }
}
