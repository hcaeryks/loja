import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
        primarySwatch: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
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
  bool _visible = true;
  bool _loggedin = false;
  int _selectedIndex = 0;
  int _queryResCount = 0;
  late final AnimationController _controller;
  PageController _pageController = PageController(initialPage: 0);
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
      String sql = "SELECT * FROM advertisement";
      anuncios = await db.rawQuery(sql);
    } else if (categoria == "" && regiao != "") {
      String sql = "SELECT * FROM advertisement WHERE state = ?";
      anuncios = await db.rawQuery(sql, [regiao]);
    } else if (categoria != "" && regiao == "") {
      String sql = "SELECT * FROM advertisement WHERE category = ?";
      anuncios = await db.rawQuery(sql, [categoria]);
    } else if (categoria != "" && regiao != "") {
      String sql =
          "SELECT * FROM advertisement WHERE category = ? AND state = ?";
      anuncios = await db.rawQuery(sql, [categoria, regiao]);
    }

    setState(() {
      _queryResCount = anuncios.length;
    });
    return anuncios;
  }

  void _logOut() {
    setState(() {
      _loggedin = false;
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
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
        );
        _widgetOptionsNL[2] = AnunciosScreen(
          loggedin: _loggedin,
          refresh: _refresh,
          insert: _insert,
          list: _list,
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

    int id = await db.insert("user", userData);
    setState(() {
      _loggedin = true;
      _visible = true;
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
      );
    });
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void _insert(String titulo, String regiao, String categoria, String preco,
      String telefone, String descricao, XFile? foto) async {
    Database db = await _recoverDataBase();
    Uint8List? blob = await foto?.readAsBytes();
    Map<String, dynamic> userData = {
      "title": titulo,
      "state": regiao,
      "category": categoria,
      "price": int.parse(preco),
      "telephone": telefone,
      "description": descricao,
      "photo": blob
    };
    int id = await db.insert("advertisement", userData);
    _list(categoria, regiao);
    setState(() {
      _widgetOptionsL[0] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
      );
      _widgetOptionsNL[2] = AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
      );
    });
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _widgetOptionsL = <Widget>[
      AnunciosScreen(
        loggedin: _loggedin,
        refresh: _refresh,
        insert: _insert,
        list: _list,
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
    if (index == 1)
      _visible = false;
    else
      _visible = true;
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
    if (index == 0 || index == 1)
      _visible = false;
    else
      _visible = true;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    List _appBars = [
      AppBar(title: Text("Anúncios encontrados: " + _queryResCount.toString())),
      null
    ];
    return Scaffold(
      appBar: SlidingAppBar(
        controller: _controller,
        visible: _visible,
        child: _appBars[0],
      ),
      body: Center(
          child: PageView(
        children: _loggedin ? _widgetOptionsL : _widgetOptionsNL,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            if (index == 0 && _loggedin)
              _visible = true;
            else if (index == 2 && !_loggedin)
              _visible = true;
            else
              _visible = false;
            _selectedIndex = index;
          });
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
          items: _loggedin ? _bottomMenuLogged : _bottomMenuNLogged,
          backgroundColor: Colors.black38,
          currentIndex: _selectedIndex,
          showUnselectedLabels: false,
          onTap: _loggedin ? _onTapLogged : _onTapNLogged),
    );
  }
}

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
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
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
