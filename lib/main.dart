import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'telas/login.dart';
import 'telas/register.dart';
import 'telas/anuncios.dart';
import 'telas/blank.dart';

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
  bool _visible = true;
  bool _loggedin = false;
  int _selectedIndex = 0;
  late final AnimationController _controller;
  PageController _pageController = PageController(initialPage: 0);
  List<Widget> _widgetOptionsL = [];
  List<Widget> _widgetOptionsNL = [];
  List _anuncios = [];

  _recoverDataBase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, "banco.db");
    Database db =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      String sql = """
            CREATE TABLE user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password VARCHAR NOT NULL
            );
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
      await db.execute(sql);
    });

    return db;
  }

  _list(String categoria, String regiao) async {
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
    _anuncios = anuncios;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _widgetOptionsL = <Widget>[AnunciosScreen(), BlankScreen()];
    _widgetOptionsNL = <Widget>[
      LoginScreen(),
      RegisterScreen(),
      AnunciosScreen(),
    ];
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
        duration: Duration(milliseconds: 500), curve: Curves.ease);
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

  List _appBars = [AppBar(title: Text("Loja")), null];

  @override
  Widget build(BuildContext context) {
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
