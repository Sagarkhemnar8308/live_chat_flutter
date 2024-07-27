import 'package:chat_app_live/screen/ui.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            title: const Text("emulator"),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      id: 1,
                    ),
                  ));
            },
          ),
          ListTile(
            title: const Text("SM"),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      id: 2,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
