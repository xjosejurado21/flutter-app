// Import necessary packages and dependencies
import 'package:app/presentation/screens/intro/intro.dart';
import 'package:app/presentation/screens/login/recover_password.dart';
import 'package:app/presentation/screens/login/register.dart';
import 'package:app/resources/functions/navigation.dart';
import 'package:app/resources/functions/login_register.dart';
import 'package:app/resources/widgets/basic.dart';
import 'package:app/resources/widgets/login_register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Define the LoginScreen widget
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize text editing controllers and get screen size
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final Size screenSize = MediaQuery.of(context).size;

    // Return MaterialApp with login screen UI
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const CustomBackButton(), // Custom back button
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            const Background(), // Custom background widget
            SingleChildScrollView(
              child: PageContent(
                emailController: emailController,
                passwordController: passwordController,
                screenSize: screenSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define the PageContent widget
class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.screenSize,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BasicLabel(
          label: "Iniciar Sesión",
          isTitle: true,
        ),
        const BasicLabel(label: "Identifícate para iniciar sesión"),
        const SizedBox(height: 50),
        BasicTextField(
          // Custom text field widget
          label: "Correo electrónico",
          controller: emailController,
        ),
        BasicTextField(
          label: "Contraseña",
          controller: passwordController,
          isPassword: true,
        ),
        LoginButton(
          emailController: emailController,
          passwordController: passwordController,
        ),
        BasicLinkLabel(
          label: '¿Olvidaste tu contraseña?',
          onTap: () {
            navigateTo(context, const RecoverPasswordScreen());
          },
        ),
        const SizedBox(height: 20),
        const BasicLabel(label: 'Otros métodos'),
        if (!kIsWeb && Platform.isIOS)
          const SignInAppleButton(), // Platform-specific sign-in button
        SignInGoogleButton(email: emailController), // Google sign-in button
        SizedBox(
          height: (!kIsWeb && Platform.isIOS
              ? screenSize.width * 0.3
              : screenSize.width * 0.45),
        ),
        const RegisterText(), // Register text and link
      ],
    );
  }
}

// Define the RegisterText widget
class RegisterText extends StatelessWidget {
  const RegisterText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BasicLabel(label: '¿No tienes cuenta?'),
        BasicLinkLabel(
          label: 'Regístrate',
          onTap: () {
            navigateToSlide(context, Durations.short4, const RegisterPage(),
                const Offset(0.0, 1.0), Offset.zero);
          },
        ),
      ],
    );
  }
}

// Define the LoginButton widget
class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: BasicButton(
        // Custom button widget
        text: 'Iniciar Sesión',
        onPressed: () {
          login(emailController, passwordController, context);
        },
      ),
    );
  }
}

// Define the custom BackButton widget
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        (!kIsWeb && Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      ),
      onPressed: () {
        navigateToSlide(context, Durations.short4, const IntroPage(),
            const Offset(1.0, 0.0), Offset.zero);
      },
    );
  }
}
