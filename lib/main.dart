import 'package:flutter/material.dart';
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
