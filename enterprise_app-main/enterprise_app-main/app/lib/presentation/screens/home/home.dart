import 'package:flutter/material.dart';
import 'package:app/resources/widgets/menu_bar.dart';  // Asegúrate de que la ruta de importación es correcta
import 'package:app/resources/widgets/home_page.dart';  // Asegúrate de que la ruta de importación es correcta

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = -1;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: const [
              HomePageBuild()
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Menu(
              currentIndex: _selectedIndex,
              onItemSelected: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
