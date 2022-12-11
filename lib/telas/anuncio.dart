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
    return const Scaffold();
  }
}
