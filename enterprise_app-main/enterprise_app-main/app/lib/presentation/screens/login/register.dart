// Import necessary packages and dependencies
import 'package:app/presentation/screens/intro/intro.dart';
import 'package:app/presentation/screens/login/login.dart';
import 'package:app/resources/functions/navigation.dart';
import 'package:app/resources/functions/login_register.dart';
import 'package:app/resources/widgets/basic.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Main entry point of the application
void main() => runApp(const RegisterPage());

// Define the RegisterScreen widget
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize text editing controllers
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    // Return MaterialApp with register screen UI
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const BackButton(), // Custom back button
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Page(
          // Page widget containing UI elements
          nameController: nameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
        ),
      ),
    );
  }
}

// Define the custom BackButton widget
class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon((Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
      onPressed: () => {
        Navigator.pushReplacement(
          // Navigate to IntroLoginScreen
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => const IntroPage(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        )
      },
    );
  }
}

// Define the Page widget
class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Background(), // Custom background widget
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BasicLabel(
                // Title label
                label: "Registrarse",
                isTitle: true,
              ),
              const BasicLabel(
                  label: "Rellene la información para registrarse"),
              BasicTextField(label: "Nombre", controller: nameController),
              BasicTextField(
                  label: "Correo electrónico", controller: emailController),
              BasicTextField(
                  label: "Contraseña",
                  controller: passwordController,
                  isPassword: true),
              BasicTextField(
                  label: "Confirmar contraseña",
                  controller: confirmPasswordController,
                  isPassword: true),
              RegisterButton(
                // Custom register button
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
              ),
              const SizedBox(height: 45),
              const LoginText(), // Login text and link
            ],
          ),
        ),
      ],
    );
  }
}

// Define the LoginText widget
class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BasicLabel(label: '¿Tienes una cuenta?'),
        BasicLinkLabel(
          label: 'Inicia sesión',
          onTap: () {
            navigateToSlide(context, Durations.short4, const LoginPage(),
                const Offset(0.0, 1.0), Offset.zero);
          },
        )
      ],
    );
  }
}

// Define the RegisterButton widget
class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: BasicButton(
        // Custom button widget
        text: 'Registrarse',
        onPressed: () {
          register(
            nameController,
            emailController,
            passwordController,
            confirmPasswordController,
            context,
          );
        },
      ),
    );
  }
}
