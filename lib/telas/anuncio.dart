import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnuncioScreen extends StatelessWidget {
  final int id;
  final double preco;
  final String titulo;
  final String categoria;
  final String regiao;
  final String descricao;
  final String telefone;
  final Uint8List foto;
  const AnuncioScreen(
      {Key? key,
      required this.id,
      required this.preco,
      required this.titulo,
      required this.categoria,
      required this.regiao,
      required this.descricao,
      required this.telefone,
      required this.foto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(flex: 0, child: Image.memory(foto)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35),
                ),
                const Spacer(),
                const Text(
                  "R\$",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.cyanAccent),
                ),
                Text(preco.toStringAsFixed(2),
                    style:
                        const TextStyle(fontSize: 20, color: Colors.cyanAccent))
              ],
            ),
            Row(
              children: [
                Text(categoria,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const Spacer(),
                Text(
                  "@$regiao",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(descricao, style: const TextStyle(fontSize: 15))),
          ])),
        ),
        const Spacer(),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              const Text(
                "Telefone: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.cyanAccent),
              ),
              Text(
                telefone,
                style: const TextStyle(fontSize: 15),
              ),
              const Spacer(),
              const Text(
                "ID: ",
                style: TextStyle(fontSize: 12),
              ),
              Text(id.toString(), style: const TextStyle(fontSize: 12))
            ]))
      ])),
    );
  }
}
