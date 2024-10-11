import 'package:app/presentation/screens/intro/logo.dart';
import 'package:app/presentation/screens/intro/intro.dart';
import 'package:app/resources/functions/navigation.dart';
import 'package:app/services/local_storage/local_storage.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MainScreen());

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Hellow world')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  LocalStorage.prefs.setBool('signed', false);
                  LocalStorage.prefs.setString('email', '');
                  LocalStorage.prefs.setString('signpassworded', '');
                  navigateTo(context, const IntroPage());
                },
                child: const Text('Cerrar sesión'),
              ),
              ElevatedButton(
                onPressed: () {
                  LocalStorage.prefs.clear();
                  navigateTo(context, const LogoPage());
                },
                child: const Text('Borrar datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
