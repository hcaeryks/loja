import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnunciosScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool loggedin;
  AnunciosScreen({Key? key, required this.loggedin}) : super(key: key);

  final List<String> _categorias = <String>[
    "",
    "Carro",
    "Eletrônico",
    "Mobília"
  ];
  final List<String> _regioes = <String>[
    "",
    "Rio de Janeiro",
    "São Paulo",
    "Minas Gerais"
  ];

  String _categoria = "";
  String _regiao = "";

  void getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Form(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: "Categorias:"),
                              value: _categoria,
                              onChanged: (val) {},
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _categorias.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ))),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: DropdownButtonFormField(
                              decoration:
                                  const InputDecoration(labelText: "Regiões:"),
                              value: _regiao,
                              onChanged: (val) {},
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _regioes.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ))),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text("Filtrar")))
                  ],
                ),
              )
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: loggedin
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Adicionar anúncio"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                                decoration:
                                    const InputDecoration(labelText: "Título:"),
                                onChanged: (text) {}),
                            TextField(
                                decoration:
                                    const InputDecoration(labelText: "Preço:"),
                                onChanged: (text) {}),
                            TextField(
                                decoration: const InputDecoration(
                                    labelText: "Telefone:"),
                                onChanged: (text) {}),
                            TextField(
                                decoration: const InputDecoration(
                                    labelText: "Descrição:"),
                                onChanged: (text) {}),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: "Categoria:"),
                              value: _categoria,
                              onChanged: (val) {},
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _categorias.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "Região:"),
                              value: _regiao,
                              onChanged: (val) {},
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _regioes.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  getImage();
                                },
                                child: const Text("Enviar Imagem"))
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Salvar")),
                        ],
                      );
                    });
              },
            )
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Erro"),
                        content: const Text(
                            "Você precisa estar logado para adicionar anúncios."),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"))
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
