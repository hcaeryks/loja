import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final Function(String name, String email, String password) register;
  RegisterScreen({
    Key? key,
    required this.register,
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

    const titleLabel = Text(
      "Ainda não possuo uma conta.",
      style: TextStyle(color: Colors.white, fontSize: 20),
    );

    final name = TextFormField(
      controller: nameC,
      keyboardType: TextInputType.name,
      autofocus: false,
      style: const TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        labelText: "Nome",
        hintText: 'Digite seu nome.',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: const TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        labelText: "E-mail",
        hintText: 'Digite seu e-mail.',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passC,
      autofocus: false,
      obscureText: true,
      style: const TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.white),
        labelText: "Senha",
        hintText: 'Digite sua senha.',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (name.controller!.text == "" ||
              email.controller!.text == "" ||
              password.controller!.text == "") {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Erro"),
                    content: const Text(
                        "Preencha todos os campos antes de continuar."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ok"))
                    ],
                  );
                });
          } else {
            register(name.controller!.text, email.controller!.text,
                password.controller!.text);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.cyanAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text('Registrar', style: TextStyle(color: Colors.black)),
      ),
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            const SizedBox(height: 48.0),
            titleLabel,
            const SizedBox(
              height: 20.0,
              width: 100,
            ),
            name,
            const SizedBox(height: 8.0),
            email,
            const SizedBox(height: 8.0),
            password,
            const SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      ),
    );
  }
}
