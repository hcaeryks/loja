import 'package:flutter/material.dart';

class BlankScreen extends StatelessWidget {
  final Function() notifyParent;
  final Function() goBack;
  const BlankScreen(
      {Key? key, required this.notifyParent, required this.goBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.door_back_door_outlined),
      title: const Text("Sair"),
      content: const Text("Tem certeza de que quer sair da sua conta?"),
      actions: <Widget>[
        TextButton(
            child: const Text("Sim"),
            onPressed: () {
              notifyParent();
            }),
        TextButton(
          child: const Text("Não"),
          onPressed: () {
            goBack();
          },
        )
      ],
    );
  }
}
