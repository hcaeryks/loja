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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(7.5), 
              child: SizedBox(
                width: 0.8*width,
                height: 0.3*height,
                child: Image.memory(foto)
              )
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(
                "Descrição: $descricao",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.cyanAccent
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(
                  "Preço: ${preco.toStringAsFixed(2)}",
                  style: const TextStyle(

                  )
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.5),
              child: Text(
                "Contato: $telefone",
                style: const TextStyle(

                )
              )
            )
          ]
        )
      )
    );
  }
}
