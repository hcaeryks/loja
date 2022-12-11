import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'anuncio.dart';

class AnunciosScreen extends StatefulWidget {
  final bool loggedin;
  final Function() refresh;
  final Function(int index) remove;
  final Function(String categoria, String regiao) list;
  final Function(String titulo, String regiao, String categoria, String preco,
      String telefone, String descricao, XFile? foto) insert;
  final Function(int id, String titulo, String regiao, String categoria,
      String preco, String telefone, String descricao, XFile? foto) edit;
  const AnunciosScreen({
    Key? key,
    required this.loggedin,
    required this.refresh,
    required this.insert,
    required this.list,
    required this.remove,
    required this.edit,
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
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            onPressed: () {
                              itemList = widget.list(_categoria, _regiao);
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyanAccent),
                            child: const Text("Filtrar")))
                  ],
                ),
              ),
              FutureBuilder<List>(
                future: itemList,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      for (int i = 0; i < (snapshot.data!.length); i++)
                        Column(
                          children: [
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: Colors.black54,
                            ),
                            Dismissible(
                              onDismissed: (DismissDirection direction) {
                                if (direction == DismissDirection.endToStart) {
                                  widget.remove(snapshot.data![i]["id"]);
                                  itemList = widget.list(_categoria, _regiao);
                                  setState(() {});
                                } else if (direction ==
                                    DismissDirection.startToEnd) {}
                              },
                              secondaryBackground: Container(
                                  color: Colors.red,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )
                                      ])),
                              background: Container(
                                  color: Colors.orange,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )
                                      ])),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (widget.loggedin == false) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Erro"),
                                          content: const Text(
                                              "É necessário estar logado para executar essa operação."),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Ok"))
                                          ],
                                        );
                                      });
                                  return false;
                                }
                                if (direction == DismissDirection.endToStart) {
                                  bool confirm = false;
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Deletar"),
                                          content: const Text(
                                              "Tem certeza que deseja remover o anúncio?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Não")),
                                            TextButton(
                                                onPressed: () {
                                                  confirm = true;
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Sim"))
                                          ],
                                        );
                                      });
                                  return confirm;
                                } else if (direction ==
                                    DismissDirection.startToEnd) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        var aux = snapshot.data![i];
                                        _categoria = aux["category"];
                                        _regiao = aux["state"];
                                        tituloC.text = aux["title"];
                                        precoC.text =
                                            aux["price"].toInt().toString();
                                        telefoneC.text = aux["telephone"];
                                        descricaoC.text = aux["description"];
                                        return AlertDialog(
                                          title: const Text("Editar anúncio"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                  controller: tituloC,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: "Título:"),
                                                  onChanged: (text) {}),
                                              TextField(
                                                  controller: precoC,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: "Preço:"),
                                                  onChanged: (text) {}),
                                              TextField(
                                                  controller: telefoneC,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              "Telefone:"),
                                                  onChanged: (text) {}),
                                              TextField(
                                                  controller: descricaoC,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              "Descrição:"),
                                                  onChanged: (text) {}),
                                              DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Categoria:"),
                                                value: _categoria,
                                                onChanged: (val) {
                                                  _categoria = val ?? "";
                                                  widget.refresh();
                                                },
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: _categorias
                                                    .map((String item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                              ),
                                              DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "Região:"),
                                                value: _regiao,
                                                onChanged: (val) {
                                                  _regiao = val ?? "";
                                                  widget.refresh();
                                                },
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items:
                                                    _regioes.map((String item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        getImage();
                                                        widget.refresh();
                                                      },
                                                      child: const Text(
                                                          "Enviar Imagem (Obrigatório)")))
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
                                                  widget.edit(
                                                      aux["id"],
                                                      tituloC.text,
                                                      _regiao,
                                                      _categoria,
                                                      precoC.text,
                                                      telefoneC.text,
                                                      descricaoC.text,
                                                      image);
                                                  itemList = widget.list(
                                                      _categoria, _regiao);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Salvar")),
                                          ],
                                        );
                                      });
                                  return false;
                                }
                                return null;
                              },
                              key: UniqueKey(),
                              child: InkWell(
                                  onTap: () {
                                    var aux = snapshot.data![i];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnuncioScreen(
                                                categoria: aux["category"],
                                                regiao: aux["state"],
                                                titulo: aux["title"],
                                                preco: aux["price"],
                                                descricao: aux["description"],
                                                telefone: aux["telephone"],
                                                id: aux["id"],
                                                foto: aux["photo"])));
                                  },
                                  child: Container(
                                      color: Colors.black12,
                                      child: Row(children: [
                                        Expanded(
                                            flex: 3,
                                            child: Image.memory(
                                                snapshot.data![i]["photo"])),
                                        Expanded(
                                            flex: 7,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  snapshot.data![i]["title"],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.cyanAccent),
                                                ),
                                                Text(
                                                    "R\$${snapshot.data![i]["price"]}")
                                              ],
                                            )),
                                      ]))),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      const Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "Fim da lista.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.normal),
                          ))
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
                        child: Text('Erro: ${snapshot.error}'),
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
                        child: Text('Esperando resultado...'),
                      ),
                    ];
                  }
                  return Center(
                      child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  ));
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
                        title: const Text("Adicionar anúncio"),
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
                              decoration:
                                  const InputDecoration(labelText: "Região:"),
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
                                padding: const EdgeInsets.all(10),
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
              backgroundColor: Colors.cyanAccent,
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
