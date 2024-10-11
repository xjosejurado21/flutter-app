// Importa las bibliotecas de Flutter y los recursos personalizados necesarios para el funcionamiento de la aplicación.
import 'package:app/presentation/screens/intro/intro.dart';
import 'package:app/resources/widgets/basic.dart';
import 'package:flutter/material.dart';
import 'resources/widgets/profile_images.dart';

// Función principal que ejecuta la aplicación y establece InfoScreen como la pantalla inicial.
void main() {
  runApp(const InfoScreen());
}

// Widget sin estado que configura el MaterialApp con un tema personalizado y el título de la aplicación.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}

// Widget con estado que gestiona la pantalla de onboarding.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

// Estado de OnboardingScreen que contiene la lógica y la UI para el proceso de onboarding.
class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();  // Controlador para la navegación de páginas.
  int _currentPage = 0;  // Índice de la página actual para el onboarding.

  @override
  Widget build(BuildContext context) {
    // Estructura visual básica que contiene el PageView y otros elementos de UI como indicadores de página y botones.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OnboardingPageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() => _currentPage = page);
                },
                itemCount: ProfileImages.images.length,
              ),
            ),
            const SizedBox(height: 8),
            PageIndicator(
              currentPage: _currentPage,
              pageCount: ProfileImages.images.length,
            ),
            const SizedBox(height: 16),
            ActionButton(
              isLastPage: _currentPage == ProfileImages.images.length - 1,
              onPressed: () {
                if (_currentPage < ProfileImages.images.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
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
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget sin estado que genera el PageView para el onboarding.
class OnboardingPageView extends StatelessWidget {
  final PageController controller;
  final Function(int) onPageChanged;
  final int itemCount;

  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.onPageChanged,
    required this.itemCount,
  });
// Esta diseñado para presentar contenido visual y textual en una forma organizada y estética
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return OnboardingContent(index: index);
      },
    );
  }
}

// Widget que muestra el contenido de cada página de onboarding.
class OnboardingContent extends StatelessWidget {
  final int index;

  const OnboardingContent({
    super.key,
    required this.index,
  });
//construye una columna con tres componentes principales: una imagen, un espacio vacío, y un texto. 
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(
            ProfileImages.images[index]['image']!,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 48),
        Text(
          ProfileImages.images[index]['text']!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Indicador de la página actual en el onboarding.
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });
  //utilizado en interfaces de usuario con carruseles o guías de onboarding donde se visualizan múltiples páginas de contenido.
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          margin: const EdgeInsets.all(4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Theme.of(context).primaryColor
                : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// Botón que se utiliza para navegar entre las páginas de onboarding o para finalizar el onboarding.
class ActionButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BasicButton (
      text: isLastPage ? 'Iniciar Sesión' : 'Siguiente',
      onPressed: onPressed,
    );
  }
}
