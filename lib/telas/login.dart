import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final Function(String email, String password) login;
  LoginScreen({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final titleLabel = Text(
      "Já possuo uma conta.",
      style: TextStyle(color: Colors.white, fontSize: 20),
    );

    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: "E-mail",
        hintText: 'Digite seu e-mail.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passC,
      autofocus: false,
      obscureText: true,
      style: TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white),
        labelText: "Senha",
        hintText: 'Digite sua senha.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          login(email.controller!.text, password.controller!.text);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          backgroundColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = TextButton(
        child: Text(
          'Esqueceu sua senha?',
          style: TextStyle(color: Colors.white70),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: Text("Não implementado."),
                      content: Text("Não espere pelo dia que isso funcionará."),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Voltar'))
                      ]));
        });

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            titleLabel,
            SizedBox(
              height: 20.0,
              width: 100,
            ),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
