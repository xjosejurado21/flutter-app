import 'package:app/resources/functions/login_register.dart';
import 'package:flutter/material.dart';

void main() => runApp(const RecoverPasswordScreen());

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Material App',
        home: SafeArea(
          child: Stack(
            children: [
              Background(),
            ],
          ),
        ));
  }
}
