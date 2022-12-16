import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'telas/login.dart';
import 'telas/register.dart';
import 'telas/anuncios.dart';
import 'telas/blank.dart';

/*








  A tabela advertisement mencionada no classroom não tem foreign key pra
  user, tornando impossível saber quem fez qual anúncio, pra não adicionar
  mais complexidade ao trabalho, fiz com que qualquer usuário logado possa
  editar, remover e criar qualquer anúncio.








*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.cyan,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.cyan,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Loja'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  bool _loggedin = false;
  int _selectedIndex = 0;
  int _queryResCount = 0;
  late final AnimationController _controller;
  final PageController _pageController = PageController(initialPage: 0);
  List<Widget> _widgetOptionsL = [];
  List<Widget> _widgetOptionsNL = [];

  _recoverDataBase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "db1.db");
    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sql1 = """
            CREATE TABLE user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password VARCHAR NOT NULL
            );
            """;
      String sql2 = """
            CREATE TABLE advertisement(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                state VARCHAR(2) NOT NULL,
                category VARCHAR NOT NULL,
                title TEXT NOT NULL,
                price REAL NOT NULL,
                telephone VARCHAR(20) NOT NULL,
                description TEXT NOT NULL,
                photo BLOB
            );
            """;
      await db.execute(sql1);
      await db.execute(sql2);
    });

    return db;
  }

  Future<List> _list(String categoria, String regiao) async {
    Database db = await _recoverDataBase();
    List anuncios = [];
    if (categoria == "" && regiao == "") {
      String sql = "SELECT * FROM advertisement ORDER BY id DESC";
      anuncios = await db.rawQuery(sql);
    } else if (categoria == "" && regiao != "") {
      String sql =
          "SELECT * FROM advertisement WHERE state = ? ORDER BY id DESC";
      anuncios = await db.rawQuery(sql, [regiao]);
    } else if (categoria != "" && regiao == "") {
      String sql =
          "SELECT * FROM advertisement WHERE category = ? ORDER BY id DESC";
      anuncios = await db.rawQuery(sql, [categoria]);
    } else if (categoria != "" && regiao != "") {
      String sql =
          "SELECT * FROM advertisement WHERE category = ? AND state = ? ORDER BY id DESC";
      anuncios = await db.rawQuery(sql, [categoria, regiao]);
    }

    setState(() {
      _queryResCount = anuncios.length;
    });
    return anuncios;
  }

  void _logOut() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      _loggedin = false;
      _visible = false;
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
    });
  }

  void _goBack() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _login(String email, String password) async {
    Database db = await _recoverDataBase();
    String sql = "SELECT COUNT(id) FROM user WHERE email = ? AND password = ?";
    var res = await db.rawQuery(sql, [email, password]);
    int count = res[0]["COUNT(id)"] as int;
    if (count > 0) {
      setState(() {
        _loggedin = true;
        _visible = true;
        _widgetOptionsL[0] = AnunciosScreen(
          loggedin: _loggedin,
          refresh: _refresh,
          insert: _insert,
          list: _list,
          remove: _deleteById,
          edit: _updateById,
        );
        _widgetOptionsNL[2] = AnunciosScreen(
          loggedin: _loggedin,
          refresh: _refresh,
          insert: _insert,
          list: _list,
          remove: _deleteById,
          edit: _updateById,
        );
      });
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Erro"),
              content: const Text("Falha ao entrar na conta."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Ok"))
              ],
            );
          });
    }
  }

  void _register(String name, String email, String password) async {
    Database db = await _recoverDataBase();

    Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "password": password
    };

    await db.insert("user", userData);
    setState(() {
      _loggedin = true;
      _visible = true;
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
    });
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _insert(String titulo, String regiao, String categoria, String preco,
      String telefone, String descricao, XFile? foto) async {
    Database db = await _recoverDataBase();
    Uint8List? blob = await foto?.readAsBytes();
    Map<String, dynamic> anuncioData = {
      "title": titulo,
      "state": regiao,
      "category": categoria,
      "price": double.parse(preco),
      "telephone": telefone,
      "description": descricao,
      "photo": blob
    };
    await db.insert("advertisement", anuncioData);
    _list(categoria, regiao);
    setState(() {
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      );
    });
  }

  void _refresh() {
    setState(() {});
  }

  void _deleteById(int id) async {
    Database db = await _recoverDataBase();
    await db.delete("advertisement", where: "id = ?", whereArgs: [id]);
  }

  void _updateById(int id, String titulo, String regiao, String categoria,
      String preco, String telefone, String descricao, XFile? foto) async {
    Database db = await _recoverDataBase();

    Uint8List? blob = await foto?.readAsBytes();
    Map<String, dynamic> anuncioData = {
      "id": id,
      "title": titulo,
      "state": regiao,
      "category": categoria,
      "photo": blob,
      "price": double.parse(preco),
      "description": descricao,
      "telephone": telefone
    };
    await db
        .update("advertisement", anuncioData, where: "id = ?", whereArgs: [id]);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _widgetOptionsL = <Widget>[
      AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      ),
      BlankScreen(
        notifyParent: _logOut,
        goBack: _goBack,
      )
    ];
    _widgetOptionsNL = <Widget>[
      LoginScreen(
        login: _login,
      ),
      RegisterScreen(
        register: _register,
      ),
      AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
        remove: _deleteById,
        edit: _updateById,
      ),
    ];
    _list("", "");
  }

  final List<BottomNavigationBarItem> _bottomMenuLogged =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Meus Anúncios"),
    BottomNavigationBarItem(icon: Icon(Icons.password), label: "Deslogar"),
  ];

  _onTapLogged(int index) {
    if (index == 1) {
      _visible = false;
    } else {
      _visible = true;
    }
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  final List<BottomNavigationBarItem> _bottomMenuNLogged =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Entrar"),
    BottomNavigationBarItem(icon: Icon(Icons.password), label: "Cadastro"),
    BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Anúncios")
  ];

  _onTapNLogged(int index) {
    if (index == 0 || index == 1) {
      _visible = false;
    } else {
      _visible = true;
    }
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    List appBars = [
      AppBar(title: Text("Anúncios encontrados: $_queryResCount")),
      null
    ];
    return Scaffold(
      appBar: SlidingAppBar(
        controller: _controller,
        visible: _visible,
        child: appBars[0],
      ),
      body: Center(
          child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            if (index == 0 && _loggedin) {
              _visible = true;
            } else if (index == 2 && !_loggedin) {
              _visible = true;
            } else {
              _visible = false;
            }
            _selectedIndex = index;
          });
        },
        children: _loggedin ? _widgetOptionsL : _widgetOptionsNL,
      )),
      bottomNavigationBar: BottomNavigationBar(
          items: _loggedin ? _bottomMenuLogged : _bottomMenuNLogged,
          backgroundColor: Colors.black38,
          selectedItemColor: Colors.cyanAccent,
          currentIndex: _selectedIndex,
          showUnselectedLabels: false,
          onTap: _loggedin ? _onTapLogged : _onTapNLogged),
    );
  }
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SlidingAppBar({
    super.key,
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position:
          Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
