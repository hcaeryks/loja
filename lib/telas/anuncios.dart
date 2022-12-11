import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnunciosScreen extends StatefulWidget {
  bool loggedin;
  final Function() refresh;
  final Function(String categoria, String regiao) list;
  final Function(String titulo, String regiao, String categoria, String preco,
      String telefone, String descricao, XFile? foto) insert;
  AnunciosScreen({
    Key? key,
    required this.loggedin,
    required this.refresh,
    required this.insert,
    required this.list,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnuncioScreen();
}

class _AnuncioScreen extends State<AnunciosScreen> {
  final tituloC = TextEditingController();
  final precoC = TextEditingController();
  final telefoneC = TextEditingController();
  final descricaoC = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late Future<List> itemList;
  XFile? image;

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
  void initState() {
    super.initState();
    itemList = widget.list("", "");
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
                              onChanged: (val) {
                                _categoria = val ?? "";
                                widget.refresh();
                              },
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
                              onChanged: (val) {
                                _regiao = val ?? "";
                                widget.refresh();
                              },
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
                            onPressed: () {
                              itemList = widget.list(_categoria, _regiao);
                              setState(() {});
                            },
                            child: const Text("Filtrar")))
                  ],
                ),
              ),
              FutureBuilder<List>(
                future: itemList,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    children = <Widget>[
                      for (var item in snapshot.data ?? [])
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 80,
                                    height: 80,
                                    child: Image.memory(item["photo"])),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(item["title"]),
                                    const Text("price")
                                  ],
                                )
                              ],
                            ),
                            const Divider(
                              height: 10,
                              thickness: 2,
                              indent: 10,
                              endIndent: 0,
                              color: Colors.black54,
                            )
                          ],
                        )
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              )
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: widget.loggedin
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
                                controller: tituloC,
                                decoration:
                                    const InputDecoration(labelText: "Título:"),
                                onChanged: (text) {}),
                            TextField(
                                controller: precoC,
                                decoration:
                                    const InputDecoration(labelText: "Preço:"),
                                onChanged: (text) {}),
                            TextField(
                                controller: telefoneC,
                                decoration: const InputDecoration(
                                    labelText: "Telefone:"),
                                onChanged: (text) {}),
                            TextField(
                                controller: descricaoC,
                                decoration: const InputDecoration(
                                    labelText: "Descrição:"),
                                onChanged: (text) {}),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  labelText: "Categoria:"),
                              value: _categoria,
                              onChanged: (val) {
                                _categoria = val ?? "";
                                widget.refresh();
                              },
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
                              onChanged: (val) {
                                _regiao = val ?? "";
                                widget.refresh();
                              },
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: _regioes.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      getImage();
                                      widget.refresh();
                                    },
                                    child: const Text("Enviar Imagem")))
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
                                widget.insert(
                                    tituloC.text,
                                    _regiao,
                                    _categoria,
                                    precoC.text,
                                    telefoneC.text,
                                    descricaoC.text,
                                    image);
                                itemList = widget.list(_categoria, _regiao);
                                setState(() {});
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
