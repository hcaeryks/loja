import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnuncioScreen extends StatelessWidget {
  int id;
  double preco;
  String titulo;
  String categoria;
  String regiao;
  String descricao;
  String telefone;
  Uint8List foto;
  AnuncioScreen(
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
    return Scaffold();
  }
}
